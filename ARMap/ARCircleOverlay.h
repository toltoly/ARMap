//
//  ARCircleOverlay.h
//  ARMap
//
//  Created by Won Kim on 2/7/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ARCircleOverlay : NSObject<MKOverlay>

@property (nonatomic, readonly) CLLocationDistance radius;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate radius:(CLLocationDistance)aRadius;


@end
