//
//  GithubUser.h
//  Github2Go
//
//  Created by Matt Remick on 1/28/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubUserDelegate <NSObject>

- (void)imageWasDownloaded:(NSIndexPath *)indexPath;

@end

@interface GithubUser : NSObject

@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) UIImage *avatar;
@property (strong,nonatomic) NSString *avatarURL;
@property (strong,nonatomic) NSNumber *githubScore;
@property (strong,nonatomic) NSString *profileURL;

@property (readwrite,nonatomic) BOOL isDownloading;

@property (unsafe_unretained) id<GitHubUserDelegate> delegate;


- (void)downloadUserAvatar:(NSIndexPath *)indexPath andCompletion:(void(^)( UIImage *pic))callback;


@end
