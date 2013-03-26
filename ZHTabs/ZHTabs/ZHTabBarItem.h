//
//  ZHTabBarItem.h
//  ZHTabs
//
//  Created by Zach Howe on 6/4/12.
//  Copyright (c) 2012 Zachary Howe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHTabBarItem : UIControl

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *badgeImage;

- (id)initWithTitle:(NSString *)title;

- (void)setSelected:(BOOL)selected;

@end
