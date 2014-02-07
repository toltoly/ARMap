//
//  ARMapViewAnnotation.m
//  ARMap
//
//  Created by Won Kim on 2/5/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARMapViewAnnotation.h"

@implementation ARMapViewAnnotation

@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	self=[super init];
    if(self!=nil)
    {
        self.title = ttl;
        self.coordinate = c2d;
    }
	return self;
}


@end
