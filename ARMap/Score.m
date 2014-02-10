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
    NSString *descriptionString = [NSString stringWithFormat:@"Score: %@ \n latitude: %@ \n longitude: %@ \n", self.score, self.latitude,self.longitude];
    return descriptionString;
    
}

@end
