//
//  Bus.h
//  MasterUpHW2
//
//  Created by Kirill on 2/5/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Route;

@interface Bus : NSManagedObject

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Route *route;

@end
