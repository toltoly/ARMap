//
//  ARMapViewAnnotation.h
//  ARMap
//
//  Created by Won Kim on 2/5/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Score.h"
@interface ARGeoPointAnnotation : NSObject<MKAnnotation>
{
    NSString *title;
    CLLocationCoordinate2D coordinate;


}

@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;


- (id)initWithObject:(PFObject *)aObject;
- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
- (id)initWithScore:(Score *)score;
@end
