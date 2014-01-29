//
//  CollectionCell.h
//  Github2Go
//
//  Created by Matt Remick on 1/28/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
