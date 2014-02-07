//
//  ARMapViewController.h
//  ARMap
//
//  Created by Won Kim on 2/5/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ARMapViewController : UIViewController<MKMapViewDelegate>


- (void)setInitialLocation:(CLLocation *)aLocation;

@end
