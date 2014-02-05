//
//  DetailViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "DetailViewController.h"
#import "Parse/Parse.h"

@interface DetailViewController ()
{
    __weak IBOutlet UIImageView *detailImageView;
    
}

@end

@implementation DetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    detailImageView.image = self.photoImage;
}


@end
