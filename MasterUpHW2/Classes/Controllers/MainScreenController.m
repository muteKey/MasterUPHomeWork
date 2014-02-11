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

#define ADD_TO_FAVOURITES_TAG                100
#define REMOVE_FROM_FAVOURITES_TAG           101

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
    if (self.currentRoute.isFavourited)
    {
        self.navigationItem.rightBarButtonItem.title = @"★";
    }
    else
    {
        self.navigationItem.rightBarButtonItem.title = @"☆";
    }
}


#pragma mark - public method -

- (void)changeTitle: (NSString *)title
{
    self.title = title;
}

#pragma mark - Routes delegate -

- (void)didSelectRoute: (Route *)route
{
    self.currentRoute = route;
    [self changeTitle: route.name];
    [self showFavSymbol];
}


@end
