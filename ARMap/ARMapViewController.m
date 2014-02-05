//
//  ARMapViewController.m
//  ARMap
//
//  Created by Won Kim on 2/5/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARMapViewController.h"
#import  "ARMapViewAnnotation.h"
@interface ARMapViewController ()
{
    
    IBOutlet MKMapView *huntMapView;
}

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
   // huntMapView.showsUserLocation=TRUE;
    
 

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
    
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }

      NSLog(@"viewForAnnotation");
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[ARMapViewAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [huntMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        if ([[annotation title] isEqualToString:@"monkey"])
            annotationView.image = [ UIImage imageNamed:@"monkey.png" ];
        else if ([[annotation title] isEqualToString:@"cat"])
            annotationView.image = [ UIImage imageNamed:@"cat.png" ];
        else
            annotationView.image = [ UIImage imageNamed:@"marker.png" ];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil; 
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
    
    for(ARMapViewAnnotation *annotation in aMapView.annotations)
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
    ARMapViewAnnotation *newAnnotation = [[ARMapViewAnnotation alloc] initWithTitle:@"monkey" andCoordinate:location ];
    
    location.latitude = (double) 37.78615;
	location.longitude = (double)-122.41040;
    ARMapViewAnnotation *newAnnotation2 = [[ARMapViewAnnotation alloc] initWithTitle:@"cat" andCoordinate:location ];
;
	[huntMapView addAnnotation:newAnnotation];
    [huntMapView addAnnotation:newAnnotation2];
    
    [self zoomToFitMapAnnotations];
    

    
}

@end
