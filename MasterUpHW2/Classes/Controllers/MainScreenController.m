//
//  MainScreenController.m
//  MasterUpHW2
//
//  Created by Kirill on 1/24/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "MainScreenController.h"
#import "Route.h"

#define loginControllerIdentifier @"loginNavigationController"

@interface MainScreenController ()

@property (nonatomic, weak) Route *currentRoute;

@end



@implementation MainScreenController

#pragma mark - View controller lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier: loginControllerIdentifier];
    
    [self presentViewController: loginController
                       animated: NO
                     completion: nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI actions -

- (IBAction)didChangeFavourites:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didChangeFavourites"
                                                        object: self.currentRoute];
    [self showFavSymbol];
}

- (void)showFavSymbol
{
    self.navigationItem.rightBarButtonItem.title = (self.currentRoute.isFavourited) ?  @"★" :  @"☆";
}

#pragma mark - Routes delegate -

- (void)didSelectRoute: (Route *)route
{
    self.currentRoute = route;
    self.title        = route.name;
    
    [self showFavSymbol];
}


@end
