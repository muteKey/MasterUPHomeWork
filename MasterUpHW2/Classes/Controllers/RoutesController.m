//
//  RoutesController.m
//  MasterUpHW2
//
//  Created by Kirill on 1/27/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "RoutesController.h"
#import <AFNetworking.h>
#import "Route.h"

#define ROUTES_URL @"http://marshrutki.com.ua/mu/routes.php"

@interface RoutesController ()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation RoutesController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
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
             
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier: CellIdentifier
                                                                      forIndexPath: indexPath];
    
    Route *currentRoute = self.data[indexPath.row];
    
    cell.textLabel.text = currentRoute.name;
    
    return cell;
}

#pragma mark - Getters -

- (NSMutableArray *)data
{
    if (!_data)
    {
        _data = [NSMutableArray new];
    }
    
    return _data;
}

@end
