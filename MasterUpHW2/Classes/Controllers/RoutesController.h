//
//  RoutesController.h
//  MasterUpHW2
//
//  Created by Kirill on 1/27/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@protocol RoutesDelegate <NSObject>

- (void)didSelectRoute: (Route *)route;

@end

@interface RoutesController : UITableViewController

@property (nonatomic, weak) id<RoutesDelegate>delegate;

@end
