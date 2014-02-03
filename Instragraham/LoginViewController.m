//
//  LoginViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    
}
@end

@implementation LoginViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.delegate = self;
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onRegisterButtonPushed:(id)sender
{
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}


@end
