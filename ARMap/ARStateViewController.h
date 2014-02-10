//
//  ARStateViewController.h
//  ARMap
//
//  Created by Won Kim on 2/6/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface ARStateViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;


-(void)saveUserInfo:(NSString*)userInfo;

@end
