//
//  ZHTabController.h
//  ZHTabs
//
//  Created by Zach Howe on 6/4/12.
//  Copyright (c) 2012 Zachary Howe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHTabBar.h"

@class ZHTabBarItem;
@class ZHTabBarController;

@protocol ZHTabbedViewControllerDelegate <NSObject>

//@property (nonatomic, readonly) ZHTabBarItem *tabItem;

@required
- (ZHTabBarItem *)tabItemForTabBarController:(ZHTabBarController *)tabBarController;

@end

#pragma mark -

@interface ZHTabBarController : UIViewController <ZHTabBarDelegate>

@property (nonatomic, assign) BOOL tabTransitionsAnimate;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) UIViewController *selectedViewController;

- (NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;

@end
