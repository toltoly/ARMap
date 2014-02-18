//
//  Score.m
//  ARMap
//
//  Created by Won Kim on 2/10/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "Score.h"


@implementation Score

@dynamic latitude;
@dynamic longitude;
@dynamic score;


- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"Score: %@ \n latitude: %f \n longitude: %f \n", self.score, [self.latitude doubleValue], [self.longitude doubleValue]];
    return descriptionString;
    
}

@end
