//
//  Weapon.h
//  ARMap
//
//  Created by Won Kim on 2/18/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weapon : NSManagedObject

@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * curBullet;
@property (nonatomic, retain) NSNumber * maxBullet;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * lock;

@end
