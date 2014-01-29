//
//  GithubUser.m
//  Github2Go
//
//  Created by Matt Remick on 1/28/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "GithubUser.h"
@interface GithubUser()

@property (strong,nonatomic) NSOperationQueue *backgroundQueue;

@end

@implementation GithubUser

-(id)init
{
    if (self = [super init]) {
        self.backgroundQueue = [NSOperationQueue new];
    }
    
    return self;
}

- (void)downloadUserAvatar:(NSIndexPath *)indexPath
{
    
    _isDownloading = YES;
    
    [self.backgroundQueue addOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_avatarURL]];
        _avatar = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate imageWasDownloaded:indexPath];
        }];
    }];
}

@end
