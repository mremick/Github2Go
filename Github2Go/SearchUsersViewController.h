//
//  SearchUsersViewController.h
//  Github2Go
//
//  Created by Matt Remick on 1/28/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubUser.h"

@interface SearchUsersViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,GitHubUserDelegate>

@end
