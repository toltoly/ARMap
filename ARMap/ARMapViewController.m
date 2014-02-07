//
//  ARMapViewController.m
//  ARMap
//
//  Created by Won Kim on 2/5/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARMapViewController.h"
#import  "ARGeoPointAnnotation.h"
#import "ARCircleOverlay.h"
#import "ARGeoQueryAnnotation.h"
#import <Parse/Parse.h>
#import "MKAnnotationView+WebCache.h"
enum PinAnnotationTypeTag {
    PinAnnotationTypeTagGeoPoint = 0,
    PinAnnotationTypeTagGeoQuery = 1
};

@interface ARMapViewController ()
{
    
    IBOutlet MKMapView *huntMapView;
    IBOutlet UISlider *slider;

    
}
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationDistance radius;
@property (nonatomic, strong) ARCircleOverlay *targetOverlay;


@end

@implementation ARMapViewController


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
    huntMapView.showsUserLocation=TRUE;
    
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            
            if (userData[@"relationship_status"]) {
                userProfile[@"relationship"] = userData[@"relationship_status"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            [self updateProfile];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
          //  [self logoutButtonTouchHandler:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];

    

    
    huntMapView.region = MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(0.05f, 0.05f));
    [self configureOverlay];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapView delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation
{
 //   mapView.centerCoordinate =userLocation.location.coordinate;
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *GeoPointAnnotationIdentifier = @"RedPinAnnotation";
    static NSString *GeoQueryAnnotationIdentifier = @"PurplePinAnnotation";
    
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

            NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];

            annotationView.draggable = YES;
           [annotationView setImageWithURL:pictureURL placeholderImage:nil Size:CGSizeMake(24,24)];
            
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

- (void)configureOverlay {
    if (self.location) {
        [huntMapView removeAnnotations:huntMapView.annotations];
        [huntMapView removeOverlays:huntMapView.overlays];
        
        ARCircleOverlay *overlay = [[ARCircleOverlay alloc] initWithCoordinate:self.location.coordinate radius:self.radius];
        [huntMapView addOverlay:overlay];
        
        ARGeoQueryAnnotation *annotation = [[ARGeoQueryAnnotation alloc] initWithCoordinate:self.location.coordinate radius:self.radius];
        [huntMapView addAnnotation:annotation];
        
        [self updateLocations];
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
#pragma mark - Button Action
- (IBAction)pressButton:(id)sender {
//    MKUserLocation *userLocation = huntMapView.userLocation;
//    MKCoordinateRegion region =
//    MKCoordinateRegionMakeWithDistance (
//                                        userLocation.location.coordinate, 20000, 20000);
//     [huntMapView setRegion:region animated:NO];
    
//    __block NSArray *annoations;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        annoations = [self parseJSONCities];
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            
//            [self.mapView addAnnotations:annoations];
//            
//        });
//    });
    
    NSLog(@"pressButton");
    CLLocationCoordinate2D location;
	location.latitude = (double) 37.78754;
	location.longitude = (double) -122.40718;
    
   // MKCoordinateRegion region =MKCoordinateRegionMakeWithDistance (location, 20000, 20000);
  //  [huntMapView setRegion:region animated:YES];
    ARGeoPointAnnotation *newAnnotation = [[ARGeoPointAnnotation alloc] initWithTitle:@"monkey" andCoordinate:location ];
    
    location.latitude = (double) 37.78615;
	location.longitude = (double)-122.41040;
    ARGeoPointAnnotation *newAnnotation2 = [[ARGeoPointAnnotation alloc] initWithTitle:@"cat" andCoordinate:location ];
;
	[huntMapView addAnnotation:newAnnotation];
    [huntMapView addAnnotation:newAnnotation2];
    
    [self zoomToFitMapAnnotations];
    

    
}

- (void)updateLocations {
    CGFloat kilometers = self.radius/1000.0f;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query setLimit:1000];
    [query whereKey:@"location"
       nearGeoPoint:[PFGeoPoint geoPointWithLatitude:self.location.coordinate.latitude
                                           longitude:self.location.coordinate.longitude]
   withinKilometers:kilometers];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                ARGeoPointAnnotation *geoPointAnnotation = [[ARGeoPointAnnotation alloc]
                                                          initWithObject:object];
                [huntMapView addAnnotation:geoPointAnnotation];
            }
        }
    }];
}


// Set received values if they are not nil and reload the table
- (void)updateProfile {
    if ([[PFUser currentUser] objectForKey:@"profile"][@"location"]) {
      //  [self.rowDataArray replaceObjectAtIndex:0 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"location"]];
    }
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"gender"]) {
      ///  [self.rowDataArray replaceObjectAtIndex:1 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"gender"]];
    }
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"birthday"]) {
       // [self.rowDataArray replaceObjectAtIndex:2 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"birthday"]];
    }
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"relationship"]) {
       // [self.rowDataArray replaceObjectAtIndex:3 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"relationship"]];
    }
    

    
    // Set the name in the header view label
    if ([[PFUser currentUser] objectForKey:@"profile"][@"name"]) {
    //    self.headerNameLabel.text = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
    }
    
    // Download the user's facebook profile picture
  //  self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
//        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];
//        
//        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
//                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                              timeoutInterval:2.0f];
//        // Run network request asynchronously
//        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
//        if (!urlConnection) {
//            NSLog(@"Failed to download picture");
//        }
    }
}



@end
