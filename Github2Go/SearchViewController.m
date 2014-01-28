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

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *searchResults;
- (IBAction)searchButtonPressed:(id)sender;
@property (strong,nonatomic) NSOperationQueue *backroundQueue;

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *searchText = self.searchBar.text;
    self.searchResults = [[NetworkController sharedController] reposForSearchString:searchText];

//    [self.backroundQueue addOperationWithBlock:^{
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//
//        }];
//
//    }];
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [self.tableView reloadData];

    [self.searchBar resignFirstResponder];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *resultsDict = [self.searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [resultsDict objectForKey:@"name"];
    
    return cell; 
}

- (IBAction)searchButtonPressed:(id)sender {
    
    [self search];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *dict = [self.searchResults objectAtIndex:indexPath.row];
        NSLog(@"dict: %@",dict);
        DetailViewController *vc = (DetailViewController *)segue.destinationViewController;
        vc.detailItem = dict;
    }
}
@end
