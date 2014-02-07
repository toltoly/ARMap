//
//  ARCircleOverlay.m
//  ARMap
//
//  Created by Won Kim on 2/7/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARCircleOverlay.h"

@implementation ARCircleOverlay
@synthesize radius = _radius;
@synthesize coordinate = _coordinate;


#pragma mark - Initialization

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate radius:(CLLocationDistance)aRadius {
    self = [super init];
    if (self) {
        _coordinate = aCoordinate;
        _radius = aRadius;
    }
    return self;
}


#pragma mark - MKAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (MKMapRect)boundingMapRect {
    MKMapPoint centerMapPoint = MKMapPointForCoordinate(_coordinate);
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(_coordinate, _radius * 2, _radius * 2);
    return MKMapRectMake(centerMapPoint.x,
                         centerMapPoint.y,
                         region.span.latitudeDelta,
                         region.span.longitudeDelta);
}


@end
