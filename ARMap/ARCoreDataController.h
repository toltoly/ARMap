//
//  ARCoreDataController.h
//  ARMap
//
//  Created by Won Kim on 2/10/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCoreDataController : NSObject
{


}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (ARCoreDataController*)getInstance;

- (void)saveUser:(NSString*)userInfo;
- (NSString*)getUser;



-(void)saveScore:(NSString*)data;
-(void)updateScore:(NSString*)data;
-(NSArray*)getScores;


-(void)saveWeapon:(NSString*)data;
-(NSString*)getWeapon:(NSNumber*)type;



- (NSURL *)applicationDocumentsDirectory;




@end
