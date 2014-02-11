//
//  Repo.m
//  Github2Go
//
//  Created by Matt Remick on 2/11/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "Repo.h"


@implementation Repo

@dynamic name;
@dynamic html_url;

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
        [self parseJsonDictionary:dictionary];
    }
    
    return self;
}

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withRepo:(Repo *)repo
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
        [self saveSeletcedRepo:repo];
    }
    
    return self;
}

- (void)parseJsonDictionary:(NSDictionary *)json
{
    self.name = [json objectForKey:@"name"];
    self.html_url = [json objectForKey:@"html_url"];
    
    [self.managedObjectContext save:nil];
}

- (void)saveSeletcedRepo:(Repo *)repo
{
    self.name = repo.name;
    self.html_url = repo.html_url;
    
    [self.managedObjectContext save:nil];
    
}

@end
