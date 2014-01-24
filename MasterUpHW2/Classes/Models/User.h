//
//  User.h
//  MasterUpHW2
//
//  Created by Администратор on 1/22/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// properties
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

// methods
+ (instancetype)userWithName: (NSString *)name
                    password: (NSString *)password;

- (void)login;
@end
