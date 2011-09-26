//
//  FestivalInfoCell.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/25/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "FestivalInfoCell.h"

@implementation FestivalInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"custom layoutSubviews running");
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.bounds = CGRectMake(11.0, 11.0, 44.0, 22.0);
    self.imageView.frame = CGRectMake(11.0, 11.0, 44.0, 22.0);
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = 66.0;
    self.textLabel.frame = textFrame;
}


@end
