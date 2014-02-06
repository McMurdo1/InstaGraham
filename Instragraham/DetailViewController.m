//
//  DetailViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "DetailViewController.h"
#import "Parse/Parse.h"
#include "CommentsViewController.h"

@interface DetailViewController ()
{
    __weak IBOutlet UIImageView *photoImageView;
    __weak IBOutlet UILabel *createdByLavel;
    __weak IBOutlet UILabel *createdOnLabel;
    
}

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self getAttributes];
}

-(void)getAttributes
{
    photoImageView.image = self.photoImage;
    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    NSString *objectId = self.objectID;
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *singleObject, NSError *error)
    {
        createdByLavel.text = [singleObject objectForKey:@"user"];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *formattedDate = [NSString new];
        NSDate *now = [NSDate date];
        NSDate *createDate = singleObject.createdAt;
        int timeInterval = [now timeIntervalSinceDate:createDate];
        NSLog(@"Now %@", now);
        NSLog(@"Create Date %@", createDate);
        NSLog(@"Time interval is %i", timeInterval);
        if (timeInterval < 60)
        {
            formattedDate = @"Just Now";
        }
        if (timeInterval >= 60 && timeInterval < 900)
        {
            formattedDate = @"A few minutes ago";
        }
        if (timeInterval >= 900 && timeInterval < 86400)
        {
            formattedDate = @"Earlier today";
        }
        if (timeInterval >= 86400)
        {
            formattedDate = [dateFormatter stringFromDate:createDate];
        }
        createdOnLabel.text = formattedDate;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CommentsViewController *cvc = segue.destinationViewController;
    
    cvc.objectID = self.objectID;
    cvc.photoImage = self.photoImage;
}



@end
