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

#define ROUTES_URL @"http://marshrutki.com.ua/mu/routes.php"

@interface RoutesController ()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation RoutesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo: self.view
                         animated: YES];
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: ROUTES_URL
      parameters: nil
         success: ^(AFHTTPRequestOperation *operation, id responseObject) {
             
             for (NSDictionary *routeParameters in responseObject)
             {
                 Route *currentRoute = [Route createRouteWithParameters: routeParameters];
                 
                 [self.data addObject: currentRoute];
             }
             
             [self.tableView reloadData];
             
             [MBProgressHUD hideHUDForView: self.view
                                  animated: YES];
             
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier: CellIdentifier
                                                                      forIndexPath: indexPath];
    
    Route *currentRoute = self.data[indexPath.row];
    
    cell.textLabel.text = currentRoute.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:               (UITableView *)tableView
        didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    SidePanelController *panelController               = (SidePanelController *)self.parentViewController;
    UINavigationController *centerNavigationController = (UINavigationController *)panelController.centerPanel;
    Route *currentRoute                                = self.data[indexPath.row];
    MainScreenController *mainScreenController         = centerNavigationController.viewControllers[0];
    
    [mainScreenController changeTitle: currentRoute.name];
    
    [self.tableView deselectRowAtIndexPath: indexPath
                                  animated: YES];
    
    [panelController showCenterPanelAnimated: YES];
}

#pragma mark - Getters -

- (NSMutableArray *)data
{
    if (!_data) // lazy instantiation
    {
        _data = [NSMutableArray new];
    }
    
    return _data;
}

@end
