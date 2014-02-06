//
//  CommentsViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/5/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "CommentsViewController.h"
#import "Parse/Parse.h"
#import "CommentTableViewCell.h"

@interface CommentsViewController () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITextView *commentTextField;
    __weak IBOutlet UIButton *postButton;
    NSMutableArray *comments;
    NSMutableArray *users;
    PFObject *comment;
    __weak IBOutlet UITableView *commentsTableView;
}

@end

@implementation CommentsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    postButton.enabled = NO;
    commentTextField.delegate = self;
    comment = [PFObject objectWithClassName:@"Comment"];

    users = [NSMutableArray new];
    comments = [NSMutableArray new];
    
    [self getCommentsForSelectedImage];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (commentTextField.text != nil)
    {
        postButton.enabled = YES;
    }
}

-(IBAction)onDismissButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPostButtonPressed:(id)sender
{
    comment[@"commentText"] = commentTextField.text;
    comment[@"photoObjectID"] = self.objectID;
    PFUser *user = [PFUser currentUser];
    comment[@"user"] = user.username;
    
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
    
    [commentTextField resignFirstResponder];
    commentTextField.text = nil;
    postButton.enabled = NO;
    [self getCommentsForSelectedImage];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(@"CommentCellReuseIdentifier")];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCellReuseIdentifier"];
    }
    
    cell.textLabel.text = [comments objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [users objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)getCommentsForSelectedImage
{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"photoObjectID" equalTo:self.objectID];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        users = [NSMutableArray new];
        comments = [NSMutableArray new];
        if (!error)
        {
            for (PFObject *object in objects)
            {
                [comments addObject:[object objectForKey:@"commentText"]];
                [users addObject:[object objectForKey:@"user"]];
                
            }
        }
        else
        {
            NSLog(@"Error retreiving comments %@", error);
        }
        [commentsTableView reloadData];
    }];
    
}

@end
