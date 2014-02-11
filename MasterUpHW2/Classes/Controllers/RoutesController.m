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
#import "DataManager.h"

#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "NetworkManager.h"

#define FAVOURITE_ROUTES_SECTION      0
#define ALL_ROUTES_SECTION            1

@interface RoutesController ()

@property (nonatomic, strong) NSArray *favouriteRoutes;
@property (nonatomic, strong) NSArray *notFavouriteRoutes;

@property (nonatomic, strong) NSManagedObjectContext *childObjectContext;

@end

@implementation RoutesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[DataManager sharedInstance] notFavoritedRoutes].count == 0 ||
        [[DataManager sharedInstance] favouritedRoutes].count == 0)
    {
        [self requestData];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(didChangeFavourites:)
                                                 name: @"didChangeFavourites"
                                               object: nil];
    [self reloadData];
    
    SidePanelController *panelController    = (SidePanelController *)self.parentViewController.parentViewController;
    UINavigationController *navController   = (UINavigationController *)panelController.centerPanel;
    MainScreenController *mainController    = [navController.viewControllers firstObject];
    self.delegate                           = mainController;

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
    
    return self.notFavouriteRoutes.count;
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
        currentRoute = self.notFavouriteRoutes[indexPath.row];
    }
    
    cell.textLabel.text       = currentRoute.name;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%.2f", currentRoute.price];
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:               (UITableView *)tableView
        didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    SidePanelController *panelController    = (SidePanelController *)self.parentViewController.parentViewController;
    
    if ([self.delegate respondsToSelector:@selector(didSelectRoute:)])
    {
        Route *currentRoute = nil;
        if (indexPath.section == FAVOURITE_ROUTES_SECTION)
        {
            currentRoute = self.favouriteRoutes[indexPath.row];
        }
        else
        {
            currentRoute = self.notFavouriteRoutes[indexPath.row];
        }
        
        [self.delegate didSelectRoute: currentRoute];
    }
    
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

- (NSManagedObjectContext *)childObjectContext
{
    if (_childObjectContext != nil)
    {
        return _childObjectContext;
    }
    
    _childObjectContext                 = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    _childObjectContext.parentContext   = [DataManager sharedInstance].objectContext;
    
    return _childObjectContext;
}


#pragma mark - Notifications reaction -

- (void)didChangeFavourites: (NSNotification *)note
{
    Route *changedRoute       = note.object;
    changedRoute.isFavourited = !changedRoute.isFavourited;
    
    [[DataManager sharedInstance] saveContext];
    
    [self reloadData];
}

#pragma mark - data retrieving methods -

- (void)reloadData
{
    self.favouriteRoutes    = [[DataManager sharedInstance] favouritedRoutes];
    self.notFavouriteRoutes = [[DataManager sharedInstance] notFavoritedRoutes];
    
    [self.tableView reloadData];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo: self.view
                         animated: YES];
    
    __weak RoutesController *weakSelf = self;
    [[NetworkManager sharedInstance] getRoutesWithCompletion: ^(NSArray *result) {
        
        [self.childObjectContext performBlock:^{
            
            NSError *error;
            for (NSDictionary *routeDict in result)
            {
                [Route createRouteWithParameters: routeDict
                          inManagedObjectContext: weakSelf.childObjectContext];
            }
            
            [weakSelf.childObjectContext save: &error];
            
            [[DataManager sharedInstance].objectContext performBlock: ^{
                
                NSError *error;
                [[DataManager sharedInstance].objectContext save: &error];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf reloadData];
                });
                
            }];
            
        }];
        
        
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

@end
