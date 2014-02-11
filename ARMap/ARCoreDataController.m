//
//  ARCoreDataController.m
//  ARMap
//
//  Created by Won Kim on 2/10/14.
//  Copyright (c) 2014 Won Kim. All rights reserved.
//

#import "ARCoreDataController.h"
#import "Score.h"
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

- (void)saveUser
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription
//                  insertNewObjectForEntityForName:@"Contacts"
//                  inManagedObjectContext:context];
//    [newContact setValue: _name.text forKey:@"name"];
//    [newContact setValue: _address.text forKey:@"address"];
//    [newContact setValue: _phone.text forKey:@"phone"];
//    _name.text = @"";
//    _address.text = @"";
//    _phone.text = @"";
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)getUser
{
    
//    NSManagedObjectContext *context =self.managedObjectContext;

    
//    NSEntityDescription *entityDesc =
//    [NSEntityDescription entityForName:@"Contacts"
//                inManagedObjectContext:context];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDesc];
//    
//    NSPredicate *pred =
//    [NSPredicate predicateWithFormat:@"(name = %@)",
//     _name.text];
//    [request setPredicate:pred];
//    NSManagedObject *matches = nil;
//    
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request
//                                              error:&error];
//    
//    if ([objects count] == 0) {
//        _status.text = @"No matches";
//    } else {
//        matches = objects[0];
//        _address.text = [matches valueForKey:@"address"];
//        _phone.text = [matches valueForKey:@"phone"];
//        _status.text = [NSString stringWithFormat:
//                        @"%lu matches found", (unsigned long)[objects count]];
//    }
//    
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
    NSManagedObject *newScore=[[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    
    if(newScore!=nil)
    {
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
    else
    {
        [self saveScore:data];
    }

    

}

-(void)getScores
{

    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Score"];

    NSArray *array=[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
 
    for(Score *score in array)
    {
        NSLog(@" score %@",score);
        
    }

    
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
