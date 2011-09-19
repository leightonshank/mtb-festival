//
//  ScheduleDetailController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/17/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleDetailController : UIViewController {
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *levelLabel;
    UILabel *lengthLabel;
    UITextView *descriptionText;
    
    NSString *name;
    NSString *time;
    NSString *level;
    NSString *length;
    NSString *description;
}

@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@property (nonatomic,retain) IBOutlet UILabel *levelLabel;
@property (nonatomic,retain) IBOutlet UILabel *lengthLabel;
@property (nonatomic,retain) IBOutlet UITextView *descriptionText;

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *level;
@property (nonatomic,retain) NSString *length;
@property (nonatomic,retain) NSString *description;


@end
