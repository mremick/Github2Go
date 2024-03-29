//
//  AppDelegate.m
//  Github2Go
//
//  Created by Matt Remick on 1/27/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"






@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize manangedObjectModel = _manangedObjectModel;
@synthesize persistantStoreCoordinator = _persistantStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
    [self saveContext];
}


- (void)saveContext
{
    //if the managed object changed, save, if error, log it
    NSManagedObjectContext *context = self.managedObjectContext;
    if (context && [context hasChanges]) {
        NSError *error;
        [context save:&error];
        if (error) {
            NSLog(@"ERROR SAVING %@",error);
        }
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    
    NSPersistentStoreCoordinator *coordinator = [self persistantStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;

}

- (NSPersistentStoreCoordinator *)persistantStoreCoordinator
{
    if (_persistantStoreCoordinator != nil) {
        return _persistantStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Github2Go.sqlite"];
    
    NSError *error = nil;
    
    _persistantStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self manangedObjectModel]];
    
    if (![_persistantStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        if (error) {
            NSLog(@"ERROR: %@",error);
        }
        
    }
    
    return _persistantStoreCoordinator;
}

- (NSManagedObjectModel *)manangedObjectModel
{
    if (_manangedObjectModel != nil) {
        return _manangedObjectModel;
    }
    
    NSURL *modeURL = [[NSBundle mainBundle] URLForResource:@"Github2Go" withExtension:@"momd"];
    _manangedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modeURL];
    return _manangedObjectModel; 
}
@end
