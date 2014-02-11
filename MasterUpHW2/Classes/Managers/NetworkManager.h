//
//  NetworkManager.h
//  MasterUpHW2
//
//  Created by Kirill on 1/31/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^SuccessBlock)(NSArray *result);
typedef void(^ErrorBlock)(NSError *error);

@interface NetworkManager : AFHTTPRequestOperationManager

+ (instancetype)sharedInstance;

- (void)getRoutesWithCompletion: (SuccessBlock)completion
                andFailureBlock: (ErrorBlock)errorBlock;

@end
