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

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didSelectRoute:)
                                                 name: didSelectRouteNotification
                                               object: nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI actions -

- (IBAction)longTapIcon: (UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Long tap detected on image icon");
    }
}

- (void)favouritesAction: (UIBarButtonItem *)sender
{
    if (sender.tag == ADD_TO_FAVOURITES_TAG)
    {
        if (self.currentRoute)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: didAddRouteToFavouritesNotification
                                                                object: nil
                                                              userInfo: @{kRouteToAddToFavs : self.currentRoute}];
            
            sender.tag       = REMOVE_FROM_FAVOURITES_TAG;
            sender.tintColor = [UIColor blackColor];
        }
        
    }
    
    else if (sender.tag == REMOVE_FROM_FAVOURITES_TAG)
    {
        if (self.currentRoute)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: didRemoveRouteFromFavouritesNotification
                                                                object: nil
                                                              userInfo: @{kRouteToRemoveFromFavs : self.currentRoute}];
            sender.tag       = ADD_TO_FAVOURITES_TAG;
            sender.tintColor = [UIColor blueColor];
        }
    }
}

- (void)addFavButton: (BOOL)isFavourite
{
    UIBarButtonItem *favButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"star.png"]
                                                                  style: UIBarButtonItemStylePlain
                                                                 target: self
                                                                 action: @selector(favouritesAction:)];
    if (isFavourite)
    {
        [favButton setTag: REMOVE_FROM_FAVOURITES_TAG];
        favButton.tintColor = [UIColor blackColor];
    }
    else
    {
        [favButton setTag: ADD_TO_FAVOURITES_TAG];
        favButton.tintColor = [UIColor blueColor];
    }

    [self.navigationItem setRightBarButtonItem: favButton];
}

#pragma mark - public method -

- (void)changeTitle: (NSString *)title
{
    self.title = title;
}

#pragma mark - Notifications reaction -

- (void)didSelectRoute: (NSNotification *)note
{
    Route *selectedRoute = note.userInfo[kSelectedRoute];
    BOOL isFavourite     = [note.userInfo[kIsRouteInFavourites] boolValue];
    
    self.currentRoute    = selectedRoute;
    
    [self changeTitle: self.currentRoute.name];
    
    [self addFavButton: isFavourite];
}

@end
