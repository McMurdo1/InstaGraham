//
//  KLMCell.m
//  Instragraham
//
//  Created by Matthew Graham on 2/5/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "KLMCell.h"

@implementation KLMCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 23)];
        [self.contentView addSubview:self.myLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
