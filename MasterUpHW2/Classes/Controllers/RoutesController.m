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

@interface RoutesController ()

@property (nonatomic, strong) NSManagedObjectContext *childObjectContext;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RoutesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    [self.fetchedResultsController performFetch: &error];
    
    if (self.fetchedResultsController.fetchedObjects.count == 0)
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
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *notFavouritedCellIdentifier = @"notFavouritedCell";
    static NSString *favouritedCellIdentifier    = @"favouritedCell";
    
    Route *currentRoute       = [self.fetchedResultsController objectAtIndexPath: indexPath];
    UITableViewCell *cell     = nil;
    
    NSLog(@"IS favourited: %d %@", currentRoute.isFavourited,currentRoute.name);
    
    if (currentRoute.isFavourited)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: favouritedCellIdentifier
                                               forIndexPath: indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier: notFavouritedCellIdentifier
                                               forIndexPath: indexPath];
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
    
    if ([self.delegate respondsToSelector: @selector(didSelectRoute:)])
    {
        Route *currentRoute = [self.fetchedResultsController objectAtIndexPath: indexPath];
        
        [self.delegate didSelectRoute: currentRoute];
    }
    
    [self.tableView deselectRowAtIndexPath: indexPath
                                  animated: YES];
    
    [panelController showCenterPanelAnimated: YES];

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

- (NSFetchedResultsController *)fetchedResultsController
{

    if (_fetchedResultsController)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request                = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName: @"Route"
                                                         inManagedObjectContext: [DataManager sharedInstance].objectContext];
    request.entity         = entityDescription;
    request.fetchBatchSize = 20;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: @"isFavourited"
                                                         ascending: NO];
    [request setSortDescriptors:@[sort]];
    
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest: request
                                                                    managedObjectContext: [DataManager sharedInstance].objectContext
                                                                      sectionNameKeyPath: nil
                                                                               cacheName: @"Route"];
    return _fetchedResultsController;
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
    NSError *error;
    [self.fetchedResultsController performFetch: &error];
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
