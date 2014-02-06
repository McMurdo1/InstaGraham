//
//  NewsFeedViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "DetailViewController.h"
#import <Parse/Parse.h>
#include <stdlib.h>

@interface NewsFeedViewController () <UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *photoScrollView;       //create scrollview control programatically
    //  NSMutableArray *images;
    UITableView *photoTableView;
    NSMutableArray *allImages;
    
    NSArray *searchResultArray; //used for search results
    
    __weak IBOutlet UITextField *searchTextField;
}


@end

@implementation NewsFeedViewController
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    allImages = [[NSMutableArray alloc] init];
    [self reloadImages:nil];
    self.view.backgroundColor = [UIColor greenColor];
    
}


-(void)reloadImages:(NSString *)userToSearchFor
{
    
    
    //UIScrollView *photoScrollView = [UIScrollView new];       //create scrollview control programatically
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    
    if (!(userToSearchFor == nil)) {
        [query whereKey:@"user" equalTo:userToSearchFor];
    }
    
    //    PFUser *user = [PFUser currentUser];
    //    [query whereKey:@"user" equalTo:user];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            // Retrieve existing objectIDs
            
            NSMutableArray *oldCompareObjectIDArray = [NSMutableArray array];
            for (UIView *view in [photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *eachButton = (UIButton *)view;
                    [oldCompareObjectIDArray addObject:[eachButton titleForState:UIControlStateReserved]];
                }
            }
            
            NSMutableArray *oldCompareObjectIDArray2 = [NSMutableArray arrayWithArray:oldCompareObjectIDArray];
            
            // If there are photos, we start extracting the data
            // Save a list of object IDs while extracting this data
            
            NSMutableArray *newObjectIDArray = [NSMutableArray array];
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    [newObjectIDArray addObject:[eachObject objectId]];
                }
            }
            
            // Compare the old and new object IDs
            NSMutableArray *newCompareObjectIDArray = [NSMutableArray arrayWithArray:newObjectIDArray];
            NSMutableArray *newCompareObjectIDArray2 = [NSMutableArray arrayWithArray:newObjectIDArray];
            if (oldCompareObjectIDArray.count > 0) {
                // New objects
                [newCompareObjectIDArray removeObjectsInArray:oldCompareObjectIDArray];
                // Remove old objects if you delete them using the web browser
                [oldCompareObjectIDArray removeObjectsInArray:newCompareObjectIDArray2];
                if (oldCompareObjectIDArray.count > 0) {
                    // Check the position in the objectIDArray and remove
                    NSMutableArray *listOfToRemove = [[NSMutableArray alloc] init];
                    for (NSString *objectID in oldCompareObjectIDArray){
                        int i = 0;
                        for (NSString *oldObjectID in oldCompareObjectIDArray2){
                            if ([objectID isEqualToString:oldObjectID]) {
                                // Make list of all that you want to remove and remove at the end
                                [listOfToRemove addObject:[NSNumber numberWithInt:i]];
                            }
                            i++;
                        }
                    }
                    
                    // Remove from the back
                    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
                    [listOfToRemove sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
                    
                    for (NSNumber *index in listOfToRemove){
                        [allImages removeObjectAtIndex:[index intValue]];
                    }
                }
            }
            
            // Add new objects
            for (NSString *objectID in newCompareObjectIDArray){
                for (PFObject *eachObject in objects){
                    if ([[eachObject objectId] isEqualToString:objectID]) {
                        NSMutableArray *selectedPhotoArray = [[NSMutableArray alloc] init];
                        [selectedPhotoArray addObject:eachObject];
                        
                        if (selectedPhotoArray.count > 0) {
                            [allImages addObjectsFromArray:selectedPhotoArray];
                        }
                    }
                }
            }
            
            // Remove and add from objects before this
            [self setUpImages:allImages];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



#pragma mark - Image Handling

-(void)getImages:(NSString *)userToSearchFor
{
    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    
    if (!(userToSearchFor == nil)) {
        [query whereKey:@"user" equalTo:userToSearchFor];
    }
    
    [query orderByDescending:@"updatedAt"];       //added by brad to reverse the images returned
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *images = [NSMutableArray new];
        for (PFObject *object in objects) {
            [images addObject:[object objectForKey:@"imageFile"]];
        }
        [photoTableView reloadData];
    }];
}


- (void)setUpImages:(NSArray *)images
{
    // Contains a list of all the BUTTONS
    //    allImages = [images mutableCopy];
    
    // This method sets up the downloaded images and places them nicely in a grid
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *imageDataArray = [NSMutableArray array];
        
        // Iterate over all images and get the data from the PFFile
        for (int i = 0; i < images.count; i++) {
            PFObject *eachObject = [images objectAtIndex:i];
            PFFile *theImage = [eachObject objectForKey:@"imageFile"];
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [imageDataArray addObject:image];
        }
        
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // Remove old grid
            for (UIView *view in [photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            
            
            // Create the buttons necessary for each image in the grid
            for (int i = 0; i < [imageDataArray count]; i++) {
                PFObject *eachObject = [images objectAtIndex:i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *image = [imageDataArray objectAtIndex:i];
                [button setImage:image forState:UIControlStateNormal];
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                button.frame = CGRectMake(75 * (i % 4) + 4 * (i % 4) + 4,
                                          75 * (i / 4) + 4 * (i / 4) + 4 + 0,
                                          75,
                                          75);
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [button setTitle:[eachObject objectId] forState:UIControlStateReserved];
                [photoScrollView addSubview:button];
            }
            
            // Size the grid accordingly
            int rows = images.count / 4;
            if (((float)images.count / 4) - rows != 0) {
                rows++;
            }
            int height = 75 * rows + 4 * rows + 4 + 0;
            
            photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            photoScrollView.clipsToBounds = YES;
        });
    });
}

-(void)buttonTouched:(id)sender
{
    NSLog(@"Image Selected");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *dvc = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    PFObject *theObject = (PFObject *)[allImages objectAtIndex:[sender tag]];
    PFFile *theImage = [theObject objectForKey:@"imageFile"];
    
    NSData *imageData;
    imageData = [theImage getData];
    UIImage *selectedPhoto = [UIImage imageWithData:imageData];
    
    NSString *objectID = theObject.objectId;
    
    dvc.photoImage = selectedPhoto;
    dvc.objectID = objectID;
    [self.navigationController pushViewController:dvc animated:YES];
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName: @"Comment"];
    searchResultArray = [query findObjects];
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}


- (IBAction)onSearchButtonPressed:(id)sender {
    [self reloadImages:searchTextField.text];
    [searchTextField resignFirstResponder];
    
}






@end
