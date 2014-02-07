//
//  ARGeoQueryAnnotation.m
//  ARMap
//
//  Created by Won Kim on 2/7/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARGeoQueryAnnotation.h"

@implementation ARGeoQueryAnnotation


@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize radius = _radius;

#pragma mark - Initialization

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate radius:(CLLocationDistance)aRadius {
    self = [super init];
    if (self) {
        _coordinate = aCoordinate;
        _radius = aRadius;
        
        [self configureLabels];
    }
    return self;
}


#pragma mark - MKAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
    [self configureLabels];
}


#pragma mark - ()

- (void)configureLabels {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    _title = @"Geo Query";
    
    _subtitle = [NSString stringWithFormat:@"Center: (%@, %@) Radius: %@ m",
                 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:_coordinate.latitude]],
                 [numberFormatter stringFromNumber:[NSNumber numberWithFloat:_coordinate.longitude]],
                 [numberFormatter stringFromNumber:[NSNumber numberWithInt:_radius]]
                 ];
}



@end
