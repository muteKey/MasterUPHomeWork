//
//  DataManager.h
//  MasterUpHW2
//
//  Created by Администратор on 2/5/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

// properties
@property (nonatomic, strong) NSManagedObjectContext *objectContext;
@property (nonatomic, strong) NSManagedObjectModel *objectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// methods
+ (instancetype)sharedInstance;
- (void)testRecordCreation;

- (void)saveContext;

- (NSArray *)favouritedRoutes;
- (NSArray *)notFavoritedRoutes;
@end
