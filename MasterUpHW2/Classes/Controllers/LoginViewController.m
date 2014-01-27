//
//  ViewController.m
//  MasterUpHW2
//
//  Created by Администратор on 1/22/14.
//  Copyright (c) 2014 Администратор. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI actions -

- (IBAction)loginTapped:(UIButton *)sender
{
    User *user = [User userWithName: self.txtLogin.text
                           password: self.txtPassword.text];
    [user login];
    
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}

- (void)touchesBegan: (NSSet *)touches
           withEvent: (UIEvent *)event
{
    [super touchesBegan: touches
              withEvent: event];
    
    UITouch *touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan)
    {
        [self.view endEditing: NO];
    }
}



@end
