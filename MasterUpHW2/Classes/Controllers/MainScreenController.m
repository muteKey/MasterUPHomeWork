//
//  MainScreenController.m
//  MasterUpHW2
//
//  Created by Kirill on 1/24/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "MainScreenController.h"

#define loginControllerIdentifier @"loginNavigationController"


@interface MainScreenController ()

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

- (IBAction)longTapIcon: (UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Long tap detected on image icon");
    }
}

#pragma mark - public method -

- (void)changeTitle: (NSString *)title
{
    self.title = title;
}

@end
