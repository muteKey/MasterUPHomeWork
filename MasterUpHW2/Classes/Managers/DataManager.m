//
//  DataManager.m
//  MasterUpHW2
//
//  Created by Администратор on 2/5/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "DataManager.h"
#import "Route.h"

@interface DataManager ()
@end

@implementation DataManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Core Data Stack -

- (NSManagedObjectModel *)objectModel
{
    if (_objectModel != nil)
    {
        return _objectModel;
    }
    
    _objectModel = [NSManagedObjectModel mergedModelFromBundles: nil];
    return _objectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSString *storePath         = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Marshrutki.sqlite"];
    NSURL *url                  = [NSURL fileURLWithPath: storePath];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.objectModel];
    NSError *error              = nil;
    
    [_persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType
                                              configuration: nil
                                                        URL: url
                                                    options: nil
                                                      error: &error];
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)objectContext
{
    if (_objectContext != nil)
    {
        return _objectContext;
    }
    
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentStoreCoordinator;
    
    if (storeCoordinator)
    {
        _objectContext                            = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
        _objectContext.persistentStoreCoordinator = storeCoordinator;
    }
    
    return _objectContext;
}

- (void)testRecordCreation
{
    Route * route = [NSEntityDescription insertNewObjectForEntityForName: @"Route"
                                                  inManagedObjectContext: self.objectContext];
    route.name      = @"302E";
    route.price     = 2.5;
    
    [[DataManager sharedInstance] saveContext];
}

#pragma mark - Application documents directory -

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark - Managed object context methods -

- (void)saveContext
{
    NSError *error = nil;
    
    if (![self.objectContext save: &error])
    {
        NSLog(@"Error saving record: %@", error);
    }
}

@end
