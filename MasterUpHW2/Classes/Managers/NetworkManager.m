//
//  NetworkManager.m
//  MasterUpHW2
//
//  Created by Kirill on 1/31/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking.h>
#import "Route.h"


@implementation NetworkManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)getRoutesWithCompletion: (SuccessBlock)completion
                andFailureBlock: (ErrorBlock)errorBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: ROUTES_URL
      parameters: nil
         success: ^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSMutableArray *allRoutes = [NSMutableArray new];
             
             for (NSDictionary *routeParameters in responseObject)
             {
                 Route *currentRoute = [Route createRouteWithParameters: routeParameters];
                 
                 [allRoutes addObject: currentRoute];
             }
             
             completion(allRoutes);
             
         } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error: %@", error);
             
             errorBlock(error);
         }];
}

@end
