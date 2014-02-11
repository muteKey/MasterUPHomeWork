//
//  Route.m
//  MasterUpHW2
//
//  Created by Kirill on 2/5/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "Route.h"


@implementation Route

@dynamic isFavourited;
@dynamic name;
@dynamic price;
@dynamic buses;

+ (void)createRouteWithParameters: (NSDictionary *)params
           inManagedObjectContext: (NSManagedObjectContext *)context
{
    Route *route        = [NSEntityDescription insertNewObjectForEntityForName: @"Route"
                                                        inManagedObjectContext: context];
    route.name          = params[@"route_title"];
    route.price         = [params[@"route_price"] floatValue];
    route.isFavourited  = NO;
}

@end
