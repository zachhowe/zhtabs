//
//  ZMTabController.m
//  ZMTabs
//
//  Created by Zach Howe on 6/4/12.
//  Copyright (c) 2012 Zachary Howe. All rights reserved.
//

#import "ZHTabBarController.h"
#import "ZHTabBarItem.h"

@interface ZHTabBarController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ZHTabBar *tabBar;
@property (nonatomic, strong) NSMutableArray *internalViewControllers;
@property (nonatomic, strong) NSMutableDictionary *internalTabBarItems;

@end

#pragma mark -

@implementation ZHTabBarController

@synthesize selectedIndex = _selectedIndex;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.tabBar = [[ZHTabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
        self.tabBar.delegate = self;
        [self.view addSubview: self.tabBar];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview: self.contentView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Public methods

- (NSArray *)viewControllers
{
    return self.internalViewControllers;
}

- (void)setViewControllers:(NSMutableArray *)viewControllers animated:(BOOL)animated
{
    if (nil != viewControllers)
    {
        if (![self.internalViewControllers isEqual:viewControllers])
        {
            _internalViewControllers = [NSMutableArray arrayWithArray:viewControllers];
            self.internalTabBarItems = [NSMutableDictionary dictionaryWithCapacity:[self.internalViewControllers count]];
            
            NSMutableArray *barItems = [[NSMutableArray alloc] init];
            
            for (UIViewController *vc in self.internalViewControllers)
            {
                ZHTabBarItem *item = [self findTabBarItemForViewController:vc];
                
                if (nil != item)
                {
                    [barItems addObject: item];
                }
            }
            
            [self.tabBar setItems:barItems];
            
            // Auto select first view controller
            [self setSelectedViewController:[self.viewControllers objectAtIndex: 0] animated:NO];
        }
    }
}

- (NSUInteger)selectedIndex
{
    return _selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    UIViewController *vc = [self.internalViewControllers objectAtIndex:selectedIndex];
    
    [self setSelectedViewController:vc];
    
    _selectedIndex = selectedIndex;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
    if (![self.internalViewControllers containsObject:newSelectedViewController]
        || [_selectedViewController isEqual:newSelectedViewController])
    {
        return;
    }
    
    if (animated)
    {
        NSInteger oldIndex = [self.internalViewControllers indexOfObject:self.selectedViewController];
        NSInteger newIndex = [self.internalViewControllers indexOfObject:newSelectedViewController];
        
        CGRect newFrame = CGRectZero;
        
        if (oldIndex < newIndex)
        {
            newSelectedViewController.view.frame = CGRectMake(CGRectGetMaxX(self.contentView.bounds),
                                                              0,
                                                              self.contentView.bounds.size.width,
                                                              self.contentView.bounds.size.height);
            
            newFrame = CGRectMake(0 - CGRectGetMaxX(self.view.bounds),
                                  0,
                                  self.selectedViewController.view.frame.size.width,
                                  self.selectedViewController.view.frame.size.height);
        }
        else
        {
            newSelectedViewController.view.frame = CGRectMake(0 - CGRectGetMaxX(self.contentView.bounds),
                                                              0,
                                                              self.contentView.bounds.size.width,
                                                              self.contentView.bounds.size.height);
            
            newFrame = CGRectMake(CGRectGetMaxX(self.view.bounds),
                                  0,
                                  self.selectedViewController.view.frame.size.width,
                                  self.selectedViewController.view.frame.size.height);
        }
        
        [self addChildViewController:newSelectedViewController];
        [self.contentView addSubview: newSelectedViewController.view];
    
        UIViewController *previousSelectedViewController = self.selectedViewController;
        
        _selectedViewController = newSelectedViewController;
        
        [UIView transitionWithView:self.view.window
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            newSelectedViewController.view.frame = self.contentView.bounds;
                            
                            previousSelectedViewController.view.frame = newFrame;
                        }
                        completion:^(BOOL finished) {
                            if (finished)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [previousSelectedViewController.view removeFromSuperview];
                                    [previousSelectedViewController removeFromParentViewController];
                                });
                            }
                        }];
    }
    else
    {    
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
        
        _selectedViewController = newSelectedViewController;
        
        [self addChildViewController:self.selectedViewController];
        [self.contentView addSubview:[self.selectedViewController view]];
        
        self.selectedViewController.view.frame = self.contentView.bounds;
        
        // Set the tab bar item to the selected state
        ZHTabBarItem *item = [self findTabBarItemForViewController:self.selectedViewController];
        [item setSelected:YES];
    }
}

- (UIViewController *)selectedViewController
{
    return _selectedViewController;
}

#pragma mark - Private methods

- (ZHTabBarItem *)findTabBarItemForViewController:(UIViewController *)viewController
{
    ZHTabBarItem *foundItem = nil;

    if ([viewController respondsToSelector:@selector(tabItemForTabBarController:)])
    {
        UIViewController<ZHTabbedViewControllerDelegate> *tabbedViewController = (UIViewController<ZHTabbedViewControllerDelegate> *)viewController;
        
        foundItem = [tabbedViewController tabItemForTabBarController:self];
    }

    // If we have a UINavigationController for our item then we need to check if the root view controller
    // of that navigation controller conforms to ZHTabbedViewControllerDelegate and get its ZHTabBarItem.
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        UIViewController *navigationControllerRootViewController = [navigationController.viewControllers objectAtIndex: 0];
        
        if ([navigationControllerRootViewController respondsToSelector:@selector(tabItemForTabBarController:)])
        {
            UIViewController<ZHTabbedViewControllerDelegate> *tabbedViewController = (UIViewController<ZHTabbedViewControllerDelegate> *)navigationControllerRootViewController;
            
            foundItem = [tabbedViewController tabItemForTabBarController:self];
        }
    }

    if (![foundItem isKindOfClass:[ZHTabBarItem class]])
    {
        // TODO - Improve autocreation of tab bars. Currently, view controllers with the same title may encounter issues if put into the same tab bar controller.
        //
        //  Proposed solutions:
        //   - vc.title + UUID ? definately overkill
        //   - vc.title.hash as NSNumber ? will this work...?
        
#warning Potentially problematic code below. Read TODO message
        
        @try
        {
            NSString *title = viewController.title;
            foundItem = self.internalTabBarItems[title];
            
            if (nil == foundItem)
            {
                foundItem = [[ZHTabBarItem alloc] initWithTitle:title];
                self.internalTabBarItems[title] = foundItem;
            }
        }
        @finally
        {
        }
    }

    return foundItem;
}

#pragma mark - ZMTabBarDelegate methods

- (void)tabBar:(ZHTabBar *)tabBar didSelectItem:(ZHTabBarItem *)item
{
    for (UIViewController *viewController in self.internalViewControllers)
    {
        ZHTabBarItem *i = [self findTabBarItemForViewController:viewController];
        
        if ([i isEqual: item])
        {
            [self setSelectedViewController:viewController animated:self.tabTransitionsAnimate];
        }
    }
}

@end
