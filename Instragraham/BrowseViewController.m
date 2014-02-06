//
//  BrowseViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "BrowseViewController.h"
#import "Parse/Parse.h"
#import "PhotoTableViewCell.h"
#import "DetailViewController.h"

@interface BrowseViewController () <UIImagePickerControllerDelegate>
{
    NSMutableArray *images;
    NSMutableArray *objectIDs;
    UITableView *photoTableView;
}

@end

@implementation BrowseViewController


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        self.parseClassName = @"Image";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    photoTableView = [UITableView new];
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [UIColor greenColor];
    [self getImages];

}

-(void)getImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        images = [NSMutableArray new];
        objectIDs = [NSMutableArray new];
        for (PFObject *object in objects) {
            if (object)
            {
                [images addObject:[object objectForKey:@"imageFile"]];
                [objectIDs addObject:object.objectId];
            }

        }
        [photoTableView reloadData];
    }];
}

#pragma mark - TableView Controls

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCellReuseIdentifier"];
    if (!cell) {
        cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhotoCellReuseIdentifier"];
    }
    cell.imageView.file = [images objectAtIndex:indexPath.row];
    [cell.imageView loadInBackground];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Image Selected");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *dvc = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    PFTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    dvc.photoImage = cell.imageView.image;
    dvc.objectID = [objectIDs objectAtIndex:indexPath.row];
    NSLog(@"Object ID is %@",[objectIDs objectAtIndex:indexPath.row]);
    
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - Camera Actions

- (IBAction)onCameraButtonPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImageView *imageView = [UIImageView new];
    imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.5f);
    [self uploadImage:imageData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Image Handling

-(void)uploadImage:(NSData *)imageData
{
    NSString *uuid = [NSString stringWithFormat:@"%@",[NSUUID UUID]];
    PFFile *imageFile = [PFFile fileWithName:@"Image" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
        PFObject *userPhoto = [PFObject objectWithClassName:@"Image"];
        [userPhoto setObject:imageFile forKey:@"imageFile"];
        PFUser *user = [PFUser currentUser];
        [userPhoto setObject:user.username forKey:@"user"];
            [userPhoto setObject:uuid forKey:@"imageName"];
            
        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (!error)
            {
                NSLog(@"Image Saved");
                [self getImages];
            }
            else
            {
                NSLog(@"Image Error");
            }
        }];
        }
        
    }];
    [photoTableView reloadData];
}

@end
