//
//  ARMapViewAnnotation.m
//  ARMap
//
//  Created by Won Kim on 2/5/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARGeoPointAnnotation.h"

@interface ARGeoPointAnnotation()
@property (nonatomic, strong) PFObject *object;
@end

@implementation ARGeoPointAnnotation

@synthesize title, coordinate,subtitle;


- (id)initWithObject:(PFObject *)aObject {
    self = [super init];
    if (self) {
        _object = aObject;
        
        PFGeoPoint *geoPoint = self.object[@"location"];
        [self setGeoPoint:geoPoint];
    }
    return self;
}

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	self=[super init];
    if(self!=nil)
    {
        self.title = ttl;
        self.coordinate = c2d;
    }
	return self;
}


- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    

}


@end
