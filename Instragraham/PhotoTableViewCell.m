//
//  PhotoTableViewCell.m
//  
//
//  Created by Matthew Graham on 2/5/14.
//
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.frame = CGRectMake( 20.0f, 0.0f, 280.0f, 280.0f);
        self.imageView.backgroundColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = YES;
        self.frame = CGRectMake(0,10.0f,300.0f,300.0f);
        
        self.contentView.frame = CGRectMake(0,10.0f,300.0f,300.0f);
        
        [self.contentView bringSubviewToFront:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 20.0f, 0.0f, 280.0f, 280.0f);
}

@end
