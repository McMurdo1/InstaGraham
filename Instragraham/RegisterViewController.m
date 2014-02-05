//
//  RegisterViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"


@interface RegisterViewController () <PFSignUpViewControllerDelegate>

@end

@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"InstaGraham";
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.signUpView.logo = titleLabel;
    [self.signUpView.usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.signUpView.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.signUpView.emailField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.signUpView.usernameField setTextColor:[UIColor purpleColor]];
    [self.signUpView.passwordField setTextColor:[UIColor purpleColor]];
    [self.signUpView.emailField setTextColor:[UIColor purpleColor]];
    [self.signUpView setBackgroundColor:[UIColor greenColor]];
    
}



@end
