//
//  ARStateViewController.m
//  ARMap
//
//  Created by Won Kim on 2/6/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARStateViewController.h"
#import <Parse/Parse.h>
#import "ARMapViewController.h"
@interface ARStateViewController ()
{
    NSMutableArray* friendsDetailsArray;
}

@end

@implementation ARStateViewController

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
    // Do any additional setup after loading the view from its nib.
    friendsDetailsArray=[NSMutableArray array];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {

        [self gotoMapView:FALSE];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (IBAction)pressLogin:(id)sender {
    
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location",@"email"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            
            
            
           // [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
           // [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
    
}



- (IBAction)pressGetfriend:(id)sender
{
  
    [self gotoMapView:TRUE];
    
   // [PFAnalytics trackEvent:@"pressGetfriend"];
    
    // Initialize the friend picker
//    FBFriendPickerViewController *friendPickerController =
//    [[FBFriendPickerViewController alloc] init];
//    // Set the friend picker title
//    friendPickerController.title = @"Pick Friends";
//    friendPickerController.allowsMultipleSelection = NO;
//    
//    // Hide the friend profile pictures
//    friendPickerController.itemPicturesEnabled = NO;
//    
//    // Configure how friends are sorted in the display.
//    // Sort friends by their last names.
//    friendPickerController.sortOrdering = FBFriendSortByLastName;
//    
//    // Configure how each friend's name is displayed.
//    // Display the last name first.
//    friendPickerController.displayOrdering = FBFriendDisplayByLastName;
//    
//    // Hide the done button
//    friendPickerController.doneButton = nil;
//
//    
//    // Hide the cancel button
//    friendPickerController.cancelButton = nil;
//    // TODO: Set up the delegate to handle picker callbacks, ex: Done/Cancel button
//    
//    // Load the friend data
//    [friendPickerController loadData];
//    // Show the picker modally
//    [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
//    NSString* query = [NSString stringWithFormat:@"SELECT uid,name,birthday_date,picture FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())"];
//    
//    // Set up the query parameter
//    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
//                                query, @"q", nil];
//    // Make the API request that uses FQL
//    [FBRequestConnection startWithGraphPath:@"/fql"
//                                 parameters:queryParam
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error) {
//                              if (!error)
//                              {
//                                  NSLog(@"result is %@",result);
//                                  
//                                  [friendsDetailsArray removeAllObjects];
//                                  NSArray *resultData = [result objectForKey:@"data"];
//                                  if ([resultData count] > 0) {
//                                      for (NSUInteger i=0; i<[resultData count] ; i++) {
//                                          [friendsDetailsArray addObject:[resultData objectAtIndex:i]];
//                                          NSLog(@"friend details are %@",friendsDetailsArray);
//                                      }
//                                  }
//                              }
//                              
//                          }];
    
    
//    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            // result will contain an array with your user's friends in the "data" key
//            NSArray *friendObjects = [result objectForKey:@"data"];
//            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
//            // Create a list of friends' Facebook IDs
//            for (NSDictionary *friendObject in friendObjects) {
//                [friendIds addObject:[friendObject objectForKey:@"id"]];
//            }
//            
//            // Construct a PFUser query that will find friends whose facebook ids
//            // are contained in the current user's friend list.
//            PFQuery *friendQuery = [PFUser query];
//            [friendQuery whereKey:@"fbId" containedIn:friendIds];
//            
//            // findObjects will return a list of PFUsers that are friends
//            // with the current user
//            NSArray *friendUsers = [friendQuery findObjects];
//            
//            NSLog(@"friends %@",friendUsers);
//        }
//    }];

}

#pragma mark - CLLocationManagerDelegate

/**
 Conditionally enable the Search/Add buttons:
 If the location manager is generating updates, then enable the buttons;
 If the location manager is failing, then disable the buttons.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


#pragma mark - MasterViewController

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
  //  _locationManager.purpose = @"Your current location is used to demonstrate PFGeoPoint and Geo Queries.";
	
	return _locationManager;
}


-(void)gotoMapView:(BOOL)anim
{
    ARMapViewController *test = [[ARMapViewController alloc]   initWithNibName:@"ARMapViewController" bundle:nil];
    [test  setInitialLocation:self.locationManager.location];
    [self.navigationController pushViewController:test animated:anim];
}

@end
