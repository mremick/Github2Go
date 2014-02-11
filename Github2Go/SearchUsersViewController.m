//
//  SearchUsersViewController.m
//  Github2Go
//
//  Created by Matt Remick on 1/28/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "SearchUsersViewController.h"
#import "CollectionCell.h"
#import "GithubUser.h"
#import "DetailViewController.h"
#import <RAMCollectionViewFlemishBondLayout.h>

@interface SearchUsersViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
- (IBAction)searchButtonSelected:(UIButton *)sender;
@property (strong,nonatomic) NSMutableArray *usersArray;
@property (strong,nonatomic) GithubUser *userClass;
@property (strong,nonatomic) NSArray *itemsFromResponseDictionary;

@end

@implementation SearchUsersViewController

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
    
    //UICollectionViewLayout *collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    //self.collectionView.collectionViewLayout = collectionViewLayout;
    
    
    self.usersArray = [NSMutableArray new];
	// Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.userClass = [[GithubUser alloc] init];
    self.userClass.delegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.usersArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    GithubUser *user = [self.usersArray objectAtIndex:indexPath.row];
    
    NSString *score = [NSString stringWithFormat:@"%@",user.githubScore];
    
    cell.nameLabel.text = user.username;
    cell.scoreLabel.text = score;
    
    if (user.avatar) {
        cell.avatarImageView.image = user.avatar;
    }
    
    else {
        if (!user.isDownloading) {
            [user downloadUserAvatar:indexPath andCompletion:^(UIImage *pic) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    cell.avatarImageView.image = pic;
                }];
            }];
        }
    }
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 60;
    
    UIColor *ios7StandardBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
    
    cell.backgroundColor = ios7StandardBlue;
    
    return cell; 
    
}

- (void)imageWasDownloaded:(NSIndexPath *)indexPath
{
    NSLog(@"collection view reloaded at index %ld",(long)indexPath.row);
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}
 


- (IBAction)searchButtonSelected:(UIButton *)sender {
    
    if (self.usersArray) {
        [self.usersArray removeAllObjects];
    }
    
    [self searchForUsers:self.searchBar.text];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    //reload collection ciew 
    
}

- (void)searchForUsers:(NSString *)searchTerm
{
    NSString *searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@",searchTerm];
    
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    NSData *searchData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchString]];
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    self.itemsFromResponseDictionary = [responseDictionary objectForKey:@"items"];
    
    NSLog(@"%@",self.itemsFromResponseDictionary);
    
    
    [self createUsersFromGithubResponse:self.itemsFromResponseDictionary];
    

}

- (void)createUsersFromGithubResponse:(NSArray *)responseArray
{
    for (NSDictionary *dictionary in responseArray) {
        GithubUser *user = [GithubUser new];
        user.delegate = self;
        user.username = [dictionary objectForKey:@"login"];
        user.githubScore = [dictionary objectForKey:@"score"];
        user.avatarURL = [dictionary objectForKey:@"avatar_url"];
        user.profileURL = [dictionary objectForKey:@"html_url"];
        
        
        
        [self.usersArray addObject:user];
    }
        
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showProfile"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        NSDictionary *dict = [self.itemsFromResponseDictionary objectAtIndex:indexPath.row];
        DetailViewController *vc = (DetailViewController *)segue.destinationViewController;
        vc.detailItem = dict;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //self.view.frame = self.parentViewController.view.frame;
    self.view.frame = self.parentViewController.view.bounds;

    NSLog(@"will rotate");

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"did rotate");
    self.view.frame = self.parentViewController.view.bounds;

}


@end
