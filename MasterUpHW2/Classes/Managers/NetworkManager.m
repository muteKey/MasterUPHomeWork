//
//  NetworkManager.m
//  MasterUpHW2
//
//  Created by Kirill on 1/31/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "NetworkManager.h"
#import "Route.h"

static NSString *BASE_URL   = @"http://marshrutki.com.ua/mu/";
static NSString *ROUTES_URL = @"routes.php";

@implementation NetworkManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL: [NSURL URLWithString: BASE_URL]];
    });
    
    return instance;
}

- (void)getRoutesWithCompletion: (SuccessBlock)completion
                andFailureBlock: (ErrorBlock)errorBlock
{
    [self GET: ROUTES_URL
      parameters: nil
         success: ^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSArray *allRoutes = (NSArray *)responseObject;
             
             if (completion)
             {
                 completion(allRoutes);
             }
             
         } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error: %@", error);
             
             if (errorBlock)
             {
                 errorBlock(error);
             }
             
         }];
}

@end
