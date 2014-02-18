//
//  User.h
//  ARMap
//
//  Created by Won Kim on 2/10/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * profiles;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * coin;

@property (nonatomic, retain) NSNumber * score;
@end
