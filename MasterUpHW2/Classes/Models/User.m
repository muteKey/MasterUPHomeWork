//
//  User.m
//  MasterUpHW2
//
//  Created by Администратор on 1/22/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)userWithName: (NSString *)name
                    password: (NSString *)password
{
    User *user    = [[User alloc] init];
    user.userName = name;
    user.password = password;
    
    return user;
}

- (void)login
{
    if (self.userName.length > 0 && self.password.length > 0)
    {
        NSLog(@"Welcome, user %@",self.userName);
    }
    else
    {
        NSLog(@"Please enter your username and password");
    }
}

@end
