//
//  BrowseViewController.m
//  Instragraham
//
//  Created by Matthew Graham on 2/3/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation BrowseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return nil;
}


@end
