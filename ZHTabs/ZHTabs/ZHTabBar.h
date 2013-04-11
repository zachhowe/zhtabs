//
//  ZHTabBar.h
//  ZHTabs
//
//  Created by Zach Howe on 6/4/12.
//  Copyright (c) 2012 Zachary Howe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHTabBar;
@class ZHTabBarItem;

@protocol ZHTabBarDelegate <NSObject>

- (void)tabBar:(ZHTabBar *)tabBar didSelectItem:(ZHTabBarItem *)item;

@end

@interface ZHTabBar : UIView

@property (nonatomic, weak) id<ZHTabBarDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *items;

@end
