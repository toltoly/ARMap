//
//  ARStateViewController.m
//  ARMap
//
//  Created by Won Kim on 2/6/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARStateViewController.h"
#import  "ARGeoPointAnnotation.h"
#import <Parse/Parse.h>
#import "ARMapViewController.h"
#import "ARCoreDataController.h"
#import "ARCircleOverlay.h"
#import "MKAnnotationView+WebCache.h"
#import "ARGeoQueryAnnotation.h"

enum PinAnnotationTypeTag {
    PinAnnotationTypeTagGeoPoint = 0,
    PinAnnotationTypeTagGeoQuery = 1
};

@interface ARStateViewController ()
{
    NSMutableArray* friendsDetailsArray;
    
    IBOutlet MKMapView *huntMapView;
    IBOutlet UISlider *slider;
}


@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationDistance radius;
@property (nonatomic, strong) ARCircleOverlay *targetOverlay;
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
    
   // huntMapView.region = MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(0.05f, 0.05f));
    [self configureOverlay];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {

      //  [self gotoMapView:FALSE];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    self.navigationItem.leftBarButtonItem.enabled = YES;
//    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
//    self.navigationItem.leftBarButtonItem.enabled = NO;
//    self.navigationItem.rightBarButtonItem.enabled = NO;
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

#pragma mark -helper

-(void)saveUserInfo:(NSString*)userInfo
{
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[userInfo dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    NSLog(@"jsonObject=%@", jsonObject);
}

#pragma mark - MapView delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation
{
    //   mapView.centerCoordinate =userLocation.location.coordinate;
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *GeoPointAnnotationIdentifier = @"RedPinAnnotation";
    static NSString *GeoQueryAnnotationIdentifier = @"PurplePinAnnotation";
    
    
    NSLog(@"mapView viewForAnnotation");
    ;
    //    if ([[annotation title] isEqualToString:@"Current Location"]) {
    //        return nil;
    //    }
    //
    //      NSLog(@"viewForAnnotation");
    //    static NSString *identifier = @"MyLocation";
    //    if ([annotation isKindOfClass:[ARMapViewAnnotation class]]) {
    //
    //        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [huntMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    //        if (annotationView == nil) {
    //            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    //        } else {
    //            annotationView.annotation = annotation;
    //        }
    //
    //        if ([[annotation title] isEqualToString:@"monkey"])
    //            annotationView.image = [ UIImage imageNamed:@"monkey.png" ];
    //        else if ([[annotation title] isEqualToString:@"cat"])
    //            annotationView.image = [ UIImage imageNamed:@"cat.png" ];
    //        else
    //            annotationView.image = [ UIImage imageNamed:@"marker.png" ];
    //        annotationView.enabled = YES;
    //        annotationView.canShowCallout = YES;
    //
    //        return annotationView;
    //    }
    
    if ([annotation isKindOfClass:[ARGeoQueryAnnotation class]]) {
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView
                                dequeueReusableAnnotationViewWithIdentifier:GeoQueryAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:GeoQueryAnnotationIdentifier];
            annotationView.tag = PinAnnotationTypeTagGeoQuery;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorPurple;
            annotationView.animatesDrop = NO;
            //    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=%@", accessToken]];
            
        //    NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];
            
         //   annotationView.draggable = YES;
         //   [annotationView setImageWithURL:pictureURL placeholderImage:nil Size:CGSizeMake(24,24)];
            
            //  annotationView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
        }
        
        return annotationView;
    } else if ([annotation isKindOfClass:[ARGeoPointAnnotation class]]) {
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView
                                dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:GeoPointAnnotationIdentifier];
            annotationView.tag = PinAnnotationTypeTagGeoPoint;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.animatesDrop = YES;
            annotationView.draggable = NO;
        }
        
        return annotationView;
    }
    
    
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    static NSString *CircleOverlayIdentifier = @"Circle";
    
    if ([overlay isKindOfClass:[ARCircleOverlay class]]) {
        ARCircleOverlay *circleOverlay = (ARCircleOverlay *)overlay;
        
        MKCircleView *annotationView =
        (MKCircleView *)[mapView dequeueReusableAnnotationViewWithIdentifier:CircleOverlayIdentifier];
        
        if (!annotationView) {
            MKCircle *circle = [MKCircle
                                circleWithCenterCoordinate:circleOverlay.coordinate
                                radius:circleOverlay.radius];
            annotationView = [[MKCircleView alloc] initWithCircle:circle];
        }
        
        if (overlay == self.targetOverlay) {
            annotationView.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.3f];
            annotationView.strokeColor = [UIColor redColor];
            annotationView.lineWidth = 1.0f;
        } else {
            annotationView.fillColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
            annotationView.strokeColor = [UIColor purpleColor];
            annotationView.lineWidth = 2.0f;
        }
        
        return annotationView;
    }
    
    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (![view isKindOfClass:[MKPinAnnotationView class]] || view.tag != PinAnnotationTypeTagGeoQuery) {
        return;
    }
    
    if (MKAnnotationViewDragStateStarting == newState) {
        [huntMapView removeOverlays:huntMapView.overlays];
    } else if (MKAnnotationViewDragStateNone == newState && MKAnnotationViewDragStateEnding == oldState) {
        MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)view;
        ARGeoQueryAnnotation *geoQueryAnnotation = (ARGeoQueryAnnotation *)pinAnnotationView.annotation;
        self.location = [[CLLocation alloc] initWithLatitude:geoQueryAnnotation.coordinate.latitude longitude:geoQueryAnnotation.coordinate.longitude];
        [self configureOverlay];
    }
}


#pragma mark - SearchViewController

- (void)setInitialLocation:(CLLocation *)aLocation {
    self.location = aLocation;
    self.radius = 1000;
}



#pragma mark - Action Button

- (IBAction)sliderDidTouchUp:(UISlider *)aSlider {
    if (self.targetOverlay) {
        [huntMapView removeOverlay:self.targetOverlay];
    }
    
    [self configureOverlay];
}

- (IBAction)sliderValueChanged:(UISlider *)aSlider {
    self.radius = aSlider.value;
    
    if (self.targetOverlay) {
        [huntMapView removeOverlay:self.targetOverlay];
    }
    
    self.targetOverlay = [[ARCircleOverlay alloc] initWithCoordinate:self.location.coordinate radius:self.radius];
    [huntMapView addOverlay:self.targetOverlay];
}

#pragma mark - Button Action
- (IBAction)pressLogin:(id)sender {
    
    
    
    ARCoreDataController* coreData=[ARCoreDataController getInstance];
    
    NSString* fmt=@"{ \"score\":\"%d\",\"latitude\":\"%f\" ,\"longitude\":\"%f\" }";
    NSString* jsonString=[NSString stringWithFormat:fmt,4000,
                          37.498287,127.145848];
    [coreData updateScore:jsonString];
    

    NSString* jsonString2=[NSString stringWithFormat:fmt,5000,
                          37.497980,127.144947];
    [coreData updateScore:jsonString2];
    
    
    
    return;
    
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
    
    ARCoreDataController* coreData=[ARCoreDataController getInstance];
    
    NSString* fmt=@"{ \"score\":\"%d\",\"latitude\":\"%d\" ,\"longitude\":\"%d\" }";
    NSString* jsonString=[NSString stringWithFormat:fmt,4000,
                          _locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude];
    
    [coreData updateScore:jsonString];
    
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:_locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Current City" message:[NSString stringWithFormat:@"Your Current City:%@",[placemark country]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alert  show];
        }
    }];
    
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
    // SELECT uid FROM user WHERE is_app_user=true AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
    
    NSString* query = [NSString stringWithFormat:@"SELECT uid,name,pic_square FROM user WHERE is_app_user=true AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())"];
    
    // Set up the query parameter
    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error)
                              {
                                  NSLog(@"result is %@",result);
                                  
                                  [friendsDetailsArray removeAllObjects];
                                  NSArray *resultData = [result objectForKey:@"data"];
                                  if ([resultData count] > 0) {
                                      for (NSUInteger i=0; i<[resultData count] ; i++) {
                                          [friendsDetailsArray addObject:[resultData objectAtIndex:i]];
                                          NSLog(@"friend details are %@",friendsDetailsArray);
                                      }
                                  }
                              }
                              
                          }];
    
    
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


- (void)configureOverlay {

    
    [self updateLocations];
}

- (void)updateLocations {
 
    
    NSLog(@" updateLocations");
    
    NSArray* scores=[[ARCoreDataController getInstance] getScores];
    
    int i=0;
    for (Score *score in scores) {
        
        
        NSLog(@" score %@",score);
        ARGeoPointAnnotation *geoPointAnnotation = [[ARGeoPointAnnotation alloc]
                                                    initWithScore:score];
        if(i==0)
            huntMapView.region = MKCoordinateRegionMake(geoPointAnnotation.coordinate, MKCoordinateSpanMake(0.01f, 0.01f));
        [huntMapView addAnnotation:geoPointAnnotation];
        i++;
    }
 
}



- (void)zoomToFitMapAnnotations {
    
    if ([huntMapView.annotations count] == 0) return;
    
    int i = 0;
    MKMapPoint points[[huntMapView.annotations count]];
    
    //build array of annotation points
    for (id<MKAnnotation> annotation in [huntMapView annotations])
        points[i++] = MKMapPointForCoordinate(annotation.coordinate);
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
    
    [huntMapView setRegion:MKCoordinateRegionForMapRect([poly boundingMapRect]) animated:YES];
    
    
}

-(void)zoomToFitMapAnnotations:(MKMapView*)aMapView
{
    if([aMapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(ARGeoPointAnnotation *annotation in aMapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [aMapView regionThatFits:region];
    [aMapView setRegion:region animated:YES];
}


@end
