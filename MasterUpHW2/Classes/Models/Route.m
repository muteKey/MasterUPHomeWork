	//
//  Route.m
//  MasterUpHW2
//
//  Created by Администратор on 1/22/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "Route.h"

#define kRouteTitle     @"route_title"

@implementation Route

+ (Route *)createRouteWithParameters: (NSDictionary *)params
{
    Route *route = [Route new];
    
    // parsing here
    route.name   = params[kRouteTitle];
    
    
    return route;
}

@end
