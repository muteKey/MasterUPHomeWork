//
//  Route.h
//  MasterUpHW2
//
//  Created by Администратор on 1/22/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject
@property (nonatomic, strong) NSString *name;

+ (Route *)createRouteWithParameters: (NSDictionary *) params;
@end
