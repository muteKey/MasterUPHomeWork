//
//  MainScreenController.m
//  MasterUpHW2
//
//  Created by Kirill on 1/24/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "MainScreenController.h"

@interface MainScreenController ()

@end

@implementation MainScreenController

#pragma mark - View controller lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI actions -

- (IBAction)longTapIcon: (UILongPressGestureRecognizer *)sender
{
    NSLog(@"Long tap detected on image icon");  
}

@end
