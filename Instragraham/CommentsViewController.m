//
//  CommentsViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/5/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "CommentsViewController.h"
#include "Parse/Parse.h"

@interface CommentsViewController ()
{
    __weak IBOutlet UITextView *commentTextField;
    
}

@end

@implementation CommentsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    commentTextField = [UITextField new];
    
    NSLog(@"Comment Text Field = %@", commentTextField.text);
    NSLog(@"Photo Object ID = %@", self.objectID);
    NSLog(@"User = %@", [PFUser currentUser].username);
}

-(IBAction)onDismissButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPostButtonPressed:(id)sender
{
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    [comment setObject:commentTextField.text forKey:@"commentText"];
    [comment setObject:self.objectID forKey:@"photoObjectID"];
    PFUser *user = [PFUser currentUser];
    [comment setObject:user.username forKey:@"user"];
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             NSLog(@"Comment Saved");
         }
         else
         {
             NSLog(@"Image Error");
         }
     }];
    
}

@end
