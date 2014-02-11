//
//  AppDelegate.h
//  Github2Go
//
//  Created by Matt Remick on 1/27/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic,readonly) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic,readonly) NSManagedObjectModel *manangedObjectModel;
@property (strong,nonatomic,readonly) NSPersistentStoreCoordinator *persistantStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory; 

@end
