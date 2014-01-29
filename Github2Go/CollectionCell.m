//
//  CollectionCell.m
//  Github2Go
//
//  Created by Matt Remick on 1/28/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setAvatarImageView:(UIImageView *)avatarImageView
{
    _avatarImageView = avatarImageView;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = 60; 
}

@end
