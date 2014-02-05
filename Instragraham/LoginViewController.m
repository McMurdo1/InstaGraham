//
//  LoginViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "RegisterViewController.h"
#import "BrowseViewController.h"

@interface LoginViewController () <UITextFieldDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
{

    
}
@end

@implementation LoginViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
}


-(void)viewDidAppear:(BOOL)animated
{
    PFLogInViewController *loginVC = [PFLogInViewController new];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.signUpController.delegate = self;
    self.delegate = self;
    titleLabel.text = @"InstaGraham";
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.logInView.logo = titleLabel;
    [self.logInView.usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.logInView.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.logInView.usernameField setTextColor:[UIColor purpleColor]];
    [self.logInView.passwordField setTextColor:[UIColor purpleColor]];
    [self.logInView setBackgroundColor:[UIColor greenColor]];
    
    RegisterViewController *registerVC = [RegisterViewController new];
    
    self.signUpController = registerVC;
    self.signUpController.delegate = self;
    
    if ([PFUser currentUser])
    {
        [self performSegueWithIdentifier:@"LoginToBrowserSegue" sender:self];
    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController performSegueWithIdentifier:@"LoginToBrowserSegue" sender:self];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
