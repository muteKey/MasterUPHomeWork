//
//  RoutesController.m
//  MasterUpHW2
//
//  Created by Kirill on 1/27/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "RoutesController.h"
#import "SidePanelController.h"
#import "MainScreenController.h"
#import "Route.h"

#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "NetworkManager.h"

#define FAVOURITE_ROUTES_SECTION      0
#define ALL_ROUTES_SECTION            1

@interface RoutesController ()

@property (nonatomic, strong) NSMutableArray *allRoutes;

@property (nonatomic, strong) NSMutableArray *favouriteRoutes;

@end

@implementation RoutesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo: self.view
                         animated: YES];
     
    [[NetworkManager sharedInstance] getRoutesWithCompletion: ^(NSArray *result) {
        
        [self.allRoutes addObjectsFromArray:result];

        [self.tableView reloadData];

        [MBProgressHUD hideHUDForView: self.view
                              animated: YES];

        
    } andFailureBlock:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView: self.view
                             animated: YES];

        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error occured", @"")
                                                             message: NSLocalizedString(@"Error loading routes", @"")
                                                            delegate: nil
                                                   cancelButtonTitle: NSLocalizedString(@"Okay", @"")
                                                   otherButtonTitles: nil, nil];
        [errorAlert show];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(didAddRouteToFavourites:)
                                                 name: didAddRouteToFavouritesNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didRemoveRouteFromFavourites:)
                                                 name: didRemoveRouteFromFavouritesNotification
                                               object: nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == FAVOURITE_ROUTES_SECTION)
    {
        return self.favouriteRoutes.count;
    }
    
    return self.allRoutes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier: CellIdentifier
                                                                      forIndexPath: indexPath];
    
    Route *currentRoute = nil;
    
    if (indexPath.section == FAVOURITE_ROUTES_SECTION)
    {
        currentRoute = self.favouriteRoutes[indexPath.row];
    }
    
    else if(indexPath.section == ALL_ROUTES_SECTION)
    {
        currentRoute = self.allRoutes[indexPath.row];
    }
    
    cell.textLabel.text = currentRoute.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:               (UITableView *)tableView
        didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    SidePanelController *panelController    = (SidePanelController *)self.parentViewController.parentViewController;
    
    BOOL isFavourite                        = (indexPath.section == FAVOURITE_ROUTES_SECTION) ? YES : NO;
    Route *currentRoute = nil;
    
    if (indexPath.section == FAVOURITE_ROUTES_SECTION)
    {
        currentRoute = self.favouriteRoutes[indexPath.row];
    }
    
    else if(indexPath.section == ALL_ROUTES_SECTION)
    {
        currentRoute = self.allRoutes[indexPath.row];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: didSelectRouteNotification
                                                        object: nil
                                                      userInfo: @{kSelectedRoute       : currentRoute,
                                                                  kIsRouteInFavourites : @(isFavourite) }];
    
    [self.tableView deselectRowAtIndexPath: indexPath
                                  animated: YES];
    
    [panelController showCenterPanelAnimated: YES];
}

- (NSString *)tableView:                 (UITableView *)tableView
                titleForHeaderInSection: (NSInteger)section
{
    if (section == FAVOURITE_ROUTES_SECTION)
    {
        return NSLocalizedString(@"Favourites", nil);
    }
    
    return NSLocalizedString(@"All", nil);
}

#pragma mark - Getters -

- (NSMutableArray *)allRoutes
{
    if (!_allRoutes) // lazy instantiation
    {
        _allRoutes = [NSMutableArray new];
    }
    
    return _allRoutes;
}

- (NSMutableArray *)favouriteRoutes
{
    if (!_favouriteRoutes)
    {
        _favouriteRoutes = [NSMutableArray new];
    }
    
    return _favouriteRoutes;
}

#pragma mark - Notifications reaction -

- (void)didAddRouteToFavourites: (NSNotification *)note
{
    Route *route = note.userInfo[kRouteToAddToFavs];
    
    [self.favouriteRoutes addObject: route];
    [self.tableView reloadData];
}

- (void)didRemoveRouteFromFavourites: (NSNotification *)note
{
    Route *route = note.userInfo[kRouteToRemoveFromFavs];
    
    [self.favouriteRoutes removeObject: route];
    [self.tableView reloadData];
}

@end
