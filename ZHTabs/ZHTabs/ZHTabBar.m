//
//  ZHTabBar.m
//  ZHTabs
//
//  Created by Zach Howe on 6/4/12.
//  Copyright (c) 2012 Zachary Howe. All rights reserved.
//

#import "ZHTabBar.h"
#import "ZHTabBarItem.h"

@interface ZHTabBar ()

@end

#pragma mark -

@implementation ZHTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setItems:(NSMutableArray *)items
{
    if (![self.items isEqual: items])
    {
        _items = items;
        
        [self layoutSubviews];
    }
}

- (void)layoutSubviews
{
    CGFloat availableWidth = self.bounds.size.width;
    NSInteger currentItemCount = [self.items count];
    
    for (int i = 0; i < [self.items count]; i++)
    {
        CGFloat itemWidth = availableWidth / currentItemCount;
        CGFloat itemX = itemWidth * i;
        CGFloat itemY = 0;
        
        ZHTabBarItem *tabBarItem = [self.items objectAtIndex: i];
        tabBarItem.frame = CGRectMake(itemX, itemY, itemWidth, self.bounds.size.height);
        [tabBarItem addTarget:self action:@selector(tabBarItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:tabBarItem];
    }
}

#pragma mark -

- (void)tabBarItemSelected:(id)sender
{
    ZHTabBarItem *newSelected = (ZHTabBarItem *)sender;
    
    for (ZHTabBarItem *i in self.items)
    {
        [i setSelected: NO];
    }
    
    [newSelected setSelected:YES];
    
    [self.delegate tabBar:self didSelectItem:newSelected];
}

@end
