//
//  NetworkController.m
//  Github2Go
//
//  Created by Matt Remick on 1/27/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

+ (NetworkController *)sharedController
{
    static dispatch_once_t pred;
    static NetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NetworkController alloc] init];
    });
    
    return shared;

}

- (NSArray *)reposForSearchString:(NSString *)searchString
{
    NSError *error;
    
    NSString *aSearchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@+&sort=stars&order=desc",searchString];
    
    NSURL *searchUrl = [NSURL URLWithString:aSearchString];
    
    NSData *searchData = [NSData dataWithContentsOfURL:searchUrl];
    
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    return searchDictionary[@"items"];
}

@end
