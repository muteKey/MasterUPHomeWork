//
//  Route.h
//  MasterUpHW2
//
//  Created by Kirill on 2/5/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Route : NSManagedObject

@property (nonatomic) BOOL isFavourited;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) float price;
@property (nonatomic, retain) NSSet *buses;

//methods
+ (void)createRouteWithParameters: (NSDictionary *)params
           inManagedObjectContext: (NSManagedObjectContext *)context;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addBusesObject:(NSManagedObject *)value;
- (void)removeBusesObject:(NSManagedObject *)value;
- (void)addBuses:(NSSet *)values;
- (void)removeBuses:(NSSet *)values;



@end
