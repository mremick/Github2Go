//
//  SideBarTableViewController.m
//  Github2Go
//
//  Created by Matt Remick on 1/27/14.
//  Copyright (c) 2014 Matt Remick. All rights reserved.
//

#import "SideBarTableViewController.h"
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchUsersViewController.h"

@interface SideBarTableViewController ()
- (IBAction)burgerButtonSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (strong,nonatomic) NSArray *viewControllerArray;

@property (strong,nonatomic) SearchViewController *searchVC;
@property (strong,nonatomic) SearchUsersViewController *searchUsersVC;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIViewController *topViewController;

@end

@implementation SideBarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 23, 15, 45, 45)];
    icon.image = [UIImage imageNamed:@"sBsvBbjY.png"];
    [self.navigationController.view addSubview:icon];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    
    UIColor *background = [UIColor blackColor];

    [self.tableView setBackgroundColor:background];
    
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.layer.cornerRadius = 27;
    self.imageView1.image = [UIImage imageNamed:@"search.png"];
    
    self.imageView2.layer.masksToBounds = YES;
    self.imageView2.layer.cornerRadius = 27;
    self.imageView2.image = [UIImage imageNamed:@"friends.png"];
    
    self.imageView3.layer.masksToBounds = YES;
    self.imageView3.layer.cornerRadius = 27;
    self.imageView3.image = [UIImage imageNamed:@"mail.png"];
    
    self.imageView4.layer.masksToBounds = YES;
    self.imageView4.layer.cornerRadius = 27;
    self.imageView4.image = [UIImage imageNamed:@"cloud.png"];
    
    self.imageView5.layer.masksToBounds = YES;
    self.imageView5.layer.cornerRadius = 27;
    self.imageView5.image = [UIImage imageNamed:@"heart.png"];
    
    self.tableView.scrollEnabled = NO;
    
    //loading the table view
    self.searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    self.searchUsersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchUsers"];
    
    self.topViewController = self.searchVC;
    
    self.viewControllerArray = [NSArray new];
    self.viewControllerArray = @[self.searchVC,self.searchUsersVC];
    
    
    //adding the view controller as a child view controller
    [self addChildViewController:self.searchVC];
    
    //setting the frame of the new of the new view controller to the size of the view
    self.searchVC.view.frame = self.view.frame;
    
    //adding the view
    [self.view addSubview:self.searchVC.view];
    [self.searchVC didMoveToParentViewController:self.searchVC];
    
    //setting the pan gesture
    
    [self setupPanGesture];
    
}

- (void)setupPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.topViewController.view addGestureRecognizer:pan];
}

- (void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    CGPoint velocity = [pan velocityInView:self.view];
    CGPoint translation = [pan translationInView:self.view];
    
    NSLog(@"translation: %f",translation.x);
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (self.topViewController.view.frame.origin.x+ translation.x > 0) {
            //if the finger is moving left move the view with the finger
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];

        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //if the sliding view is past halfway of the locl it in place
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 2) {
            [self lockSideBar];
        }
        
        if (self.topViewController.view.frame.origin.x < self.view.frame.size.width / 2) {
            [UIView animateWithDuration:.4 animations:^{
                //self.searchVC.view.frame = self.view.frame;
                [self closeSideBar];
            } completion:^(BOOL finished) {
                //[self closeSideBar];
            }];
        }
    }
}

- (void)lockSideBar
{
    
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .8, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)closeSideBar
{
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionOverrideInheritedDuration animations:^{
        NSLog(@"self.y %f search y%f",self.view.frame.origin.y,self.topViewController.view.frame.origin.y);
        self.topViewController.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index selected at: %ld",(long)indexPath.row);
    
    
    UIViewController *newVC = [self.viewControllerArray objectAtIndex:indexPath.row];
    
    //adding the view controller as a child view controller
    [self addChildViewController:newVC];
    
    //setting the frame of the new of the new view controller to the size of the view
    newVC.view.frame = self.view.bounds;
    
    //adding the view
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:newVC];
    
    //animate old view out
    //animate new view in
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            newVC.view.frame = self.view.bounds;
        } completion:^(BOOL finished) {
            NSLog(@"setup pan gesture on new view controller");
            [self setupPanGesture];
        }];
    }];
    
    //remove child
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    self.topViewController = newVC;

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)burgerButtonSelected:(id)sender {
    
    NSLog(@"BURGER BUTTON");
    
    
}
@end
