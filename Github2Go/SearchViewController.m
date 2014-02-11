//
//  SideBarIPhoneViewController.m
//  Github2Go
//
//  Created by Matt Remick on 1/27/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkController.h"
#import "SideBarTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "SearchUsersViewController.h"
#import <CoreData/CoreData.h>
#import "Repo.h"
#import "AppDelegate.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *searchResults;
- (IBAction)searchButtonPressed:(id)sender;
@property (strong,nonatomic) NSOperationQueue *backroundQueue;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.searchResults = [NSArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    self.navigationController.title = @"Search Repos";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)search
{
    
    
    
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
    
    [fetchrequest setEntity:entity];
    
    NSError *error;
    
    
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error]
    ;
    
    for (NSManagedObject *managedObject in items) {
        [self.managedObjectContext deleteObject:managedObject];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *searchText = self.searchBar.text;
    
    self.searchResults = [NSMutableArray new];
    
    self.searchResults = [[NetworkController sharedController] reposForSearchString:searchText];

//    [self.backroundQueue addOperationWithBlock:^{
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//
//        }];
//
//    }];
    
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    
    
    for (NSDictionary *dictionary in self.searchResults) {
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
        
        
        Repo *repo = [[Repo alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext withJsonDictionary:dictionary];
        
        [repo.managedObjectContext save:nil];


    }
    


    //[self.tableView reloadData];

    [self.searchBar resignFirstResponder];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Repo *repo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = repo.name;
    
    return cell; 
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Repo *selectedRepo = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
//    
//    Repo *saveSelectedRepo = [[Repo alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext withRepo:selectedRepo];
//    
//    [selectedRepo.managedObjectContext save:nil];
//    
//}

- (IBAction)searchButtonPressed:(id)sender {
    
    [self search];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Repo *repo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        DetailViewController *vc = (DetailViewController *)segue.destinationViewController;
        vc.detailItem = repo;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //self.view.frame = self.parentViewController.view.frame;
    self.view.frame = self.parentViewController.view.bounds;
    NSLog(@"will called");

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"did rotate");
    //self.view.frame = self.parentViewController.view.bounds;
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *EntityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
    request.entity = EntityDescription;
    request.fetchBatchSize = 25;
    
    
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Repo"];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error]
    ;
    
    if ([items count]) {
        [self.fetchedResultsController performFetch:&error];
    }
    
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

#pragma mark - fetch delegate

//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{
//    
//    UITableView *tableView = self.tableView;
//
//    
//    switch (type) {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationLeft];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            
//        case NSFetchedResultsChangeUpdate:
//            [tableView ];
//        
//            
//            
//        default:
//            break;
//    }
//}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableview = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
             break;
        case NSFetchedResultsChangeUpdate:
             [tableview cellForRowAtIndexPath:indexPath];
            break;
    }
}
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
