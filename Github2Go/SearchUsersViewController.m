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

@interface SearchUsersViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
- (IBAction)searchButtonSelected:(UIButton *)sender;
@property (strong,nonatomic) NSMutableArray *usersArray;
@property (strong,nonatomic) GithubUser *userClass;

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
            [user downloadUserAvatar:indexPath];
        }
    }
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 60; 
    
    UIColor *cellBackgroundColor = [UIColor colorWithRed:0.049 green:0.216 blue:0.580 alpha:1.000];
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
    
}

- (void)searchForUsers:(NSString *)searchTerm
{
    NSString *searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@",searchTerm];
    
    NSError *error;
    
    NSData *searchData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchString]];
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *itemsFromResponseDictionary = [responseDictionary objectForKey:@"items"];
    
    
    [self createUsersFromGithubResponse:itemsFromResponseDictionary];
    

}

- (void)createUsersFromGithubResponse:(NSArray *)responseArray
{
    for (NSDictionary *dictionary in responseArray) {
        GithubUser *user = [GithubUser new];
        user.delegate = self;
        user.username = [dictionary objectForKey:@"login"];
        user.githubScore = [dictionary objectForKey:@"score"];
        user.avatarURL = [dictionary objectForKey:@"avatar_url"];
        
        [self.usersArray addObject:user];
    }
        
    [self.collectionView reloadData];
}
@end
