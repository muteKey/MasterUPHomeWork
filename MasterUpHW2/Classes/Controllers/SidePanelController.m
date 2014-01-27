//
//  SidePanelController.m
//  MasterUpHW2
//
//  Created by Kirill on 1/27/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "SidePanelController.h"

#define mainControllerIdentifier        @"mainNavigationController"
#define routesControllerIdentifier      @"routesController"

@interface SidePanelController ()

@end

@implementation SidePanelController

#pragma mark - UIViewController lifecycle -

- (void)awakeFromNib
{
    [self setLeftPanel:   [self.storyboard instantiateViewControllerWithIdentifier: routesControllerIdentifier] ];
    [self setCenterPanel: [self.storyboard instantiateViewControllerWithIdentifier: mainControllerIdentifier] ];
}

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

@end
