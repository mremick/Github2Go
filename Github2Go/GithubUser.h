//
//  GithubUser.h
//  Github2Go
//
//  Created by Matt Remick on 1/28/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GithubUser : NSObject

@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) UIImage *avatar;
@property (strong,nonatomic) NSString *avatarURL;
@property (strong,nonatomic) NSNumber *githubScore;

@property (readwrite,nonatomic) BOOL isDownloading;

- (void)downloadUserAvatar;


@end
