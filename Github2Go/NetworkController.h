//
//  NetworkController.h
//  Github2Go
//
//  Created by Matt Remick on 1/27/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

+ (NetworkController *)sharedController;

- (NSArray *)reposForSearchString:(NSString *)searchString;

@end
