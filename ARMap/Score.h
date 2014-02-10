//
//  Score.h
//  ARMap
//
//  Created by Won Kim on 2/10/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * score;

@end
