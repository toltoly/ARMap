//
//  ARCoreDataController.m
//  ARMap
//
//  Created by Won Kim on 2/10/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARCoreDataController.h"
#import "Score.h"
#import "User.h"
#import "Weapon.h"
@implementation ARCoreDataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


static ARCoreDataController *sharedInstance;

+ (ARCoreDataController*)getInstance {
	
	@synchronized(self) {
		if(!sharedInstance) {
            sharedInstance = [[ARCoreDataController alloc] init];
		}
	}
	
	return sharedInstance;
}

- (id)init{
    self = [super init];
    if(self){

	}
    return self;
}

- (void)saveUser:(NSString*)userInfo
{
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[userInfo dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:0 error:NULL];
    NSLog(@"jsonObject=%@", jsonObject);

    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"objectId==%@",jsonObject[@"objectId"]];
    fetchRequest.predicate=predicate;
    User *user=(User*)[[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    
//   NSString * profiles;
//    NSString * objectId;
//   NSNumber * level;
//    NSNumber * coin;
//    NSNumber * score;
    
    
    if(user!=nil)
    {

        user.profiles=jsonObject[@"profiles"];
        user.objectId=jsonObject[@"objectId"] ;
        user.level=[NSNumber numberWithDouble:[jsonObject[@"level"] integerValue]] ;
        user.coin=[NSNumber numberWithInt:[jsonObject[@"coin"]integerValue]];
        user.score=[NSNumber numberWithDouble:[jsonObject[@"score"] integerValue]] ;

        
    }
    else
    {
        User *newUser= [NSEntityDescription
                                    insertNewObjectForEntityForName:@"User"
                                    inManagedObjectContext:managedObjectContext];
        
        newUser.profiles=jsonObject[@"profiles"];
        newUser.objectId=jsonObject[@"objectId"] ;
        newUser.level=[NSNumber numberWithDouble:[jsonObject[@"level"] integerValue]] ;
        newUser.coin=[NSNumber numberWithInt:[jsonObject[@"coin"]integerValue]];
        newUser.score=[NSNumber numberWithDouble:[jsonObject[@"score"] integerValue]] ;
    }
    
    
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSString*)getUser
{
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSArray *array=[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    for(User *user in array)
    {
        NSLog(@" score %@",user);
        
    }

    return nil;
}

-(void)saveScore:(NSString*)data
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    NSLog(@"jsonObject=%@", jsonObject);
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    
    NSManagedObject *newScore= [NSEntityDescription
                  insertNewObjectForEntityForName:@"Score"
                  inManagedObjectContext:managedObjectContext];
    [newScore setValue:[NSNumber numberWithInt:[jsonObject[@"score"] integerValue]] forKey:@"score"];
    [newScore setValue: [NSNumber numberWithDouble:[jsonObject[@"latitude"] doubleValue]]  forKey:@"latitude"];
    [newScore setValue: [NSNumber numberWithDouble:[jsonObject[@"longitude"] doubleValue]]  forKey:@"longitude"];

    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    
}

-(void)updateScore:(NSString*)data
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:0 error:NULL];
    NSLog(@"jsonObject=%@", jsonObject);
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Score"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"latitude==%@ AND longitude==%@ ",jsonObject[@"latitude"],jsonObject[@"longitude"]];
    fetchRequest.predicate=predicate;
    Score *newScore=(Score*)[[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    
    if(newScore!=nil)
    {
        if([newScore.score integerValue]<[jsonObject[@"score"]integerValue])
        {
            NSLog(@"Update Score %d",[newScore.score integerValue]);
            
            newScore.score=[NSNumber numberWithInt:[jsonObject[@"score"]integerValue]];
            newScore.latitude=[NSNumber numberWithDouble:[jsonObject[@"latitude"] doubleValue]] ;
            newScore.longitude=[NSNumber numberWithDouble:[jsonObject[@"longitude"] doubleValue]] ;

            if (managedObjectContext != nil) {
                if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
        }
        }
        
    }
    else
    {
        [self saveScore:data];
    }

    

}

-(NSArray*)getScores
{

    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Score"];

    NSArray *array=[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
 
    for(Score *score in array)
    {
        NSLog(@" score %@",score);
        
    }

    return  array;
    
}


-(void)saveWeapon:(NSString*)data
{
    
//    NSNumber * level;
//    NSNumber * curBullet;
//    NSNumber * maxBullet;
//    NSNumber * type;
//    NSNumber * power;
//    NSNumber * lock;
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:0 error:NULL];
    NSLog(@"jsonObject=%@", jsonObject);
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Weapon"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"type==%@",jsonObject[@"type"]];
    fetchRequest.predicate=predicate;
    Weapon *weapon=(Weapon*)[[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    

    
    
    if(weapon!=nil)
    {

        weapon.level=[NSNumber numberWithDouble:[jsonObject[@"level"] integerValue]] ;
        weapon.curBullet=[NSNumber numberWithInt:[jsonObject[@"curBullet"]integerValue]];
        weapon.maxBullet=[NSNumber numberWithDouble:[jsonObject[@"maxBullet"] integerValue]] ;
        weapon.type=[NSNumber numberWithDouble:[jsonObject[@"type"] integerValue]] ;
        weapon.power=[NSNumber numberWithInt:[jsonObject[@"power"]integerValue]];
        weapon.lock=[NSNumber numberWithDouble:[jsonObject[@"lock"] boolValue]] ;
        
    }
    else
    {
        Weapon *newWeapon= [NSEntityDescription
                        insertNewObjectForEntityForName:@"Weapon"
                        inManagedObjectContext:managedObjectContext];
        
        newWeapon.level=[NSNumber numberWithDouble:[jsonObject[@"level"] integerValue]] ;
        newWeapon.curBullet=[NSNumber numberWithInt:[jsonObject[@"curBullet"]integerValue]];
        newWeapon.maxBullet=[NSNumber numberWithDouble:[jsonObject[@"maxBullet"] integerValue]] ;
        newWeapon.type=[NSNumber numberWithDouble:[jsonObject[@"type"] integerValue]] ;
        newWeapon.power=[NSNumber numberWithInt:[jsonObject[@"power"]integerValue]];
        newWeapon.lock=[NSNumber numberWithDouble:[jsonObject[@"lock"] boolValue]] ;
    }
    
    
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }


    
}
-(NSString*)getWeapon:(NSNumber*)type
{
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Weapon"];
    
    NSArray *array=[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"type==%@",type];
    fetchRequest.predicate=predicate;
    
    for(User *user in array)
    {
        NSLog(@" score %@",user);
        
    }

    return  nil;
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UserInfo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UserInfo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
