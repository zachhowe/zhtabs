//
//  ZHTabBarItem.m
//  ZHTabs
//
//  Created by Zach Howe on 6/4/12.
//  Copyright (c) 2012 Zachary Howe. All rights reserved.
//

#import "ZHTabBarItem.h"
#import "ZHTabBar.h"

@interface ZHTabBarItem ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

#pragma mark -

@implementation ZHTabBarItem

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.title = title;
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = self.title;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview: self.titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    self.backgroundColor = selected ? [UIColor grayColor] : [UIColor darkGrayColor];
    self.imageView.image = selected ? self.normalImage : self.selectedImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 20);
}

@end
