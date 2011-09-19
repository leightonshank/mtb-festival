//
//  Schedule.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/17/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleDetailController.h"

@interface ScheduleController : UITableViewController {
    NSArray *list;
    UITableViewCell *scheduleCell;
    
    ScheduleDetailController *detailView;
}

@property (nonatomic,retain) NSArray *list;
@property (nonatomic,retain) IBOutlet UITableViewCell *scheduleCell;

@property (nonatomic,retain) ScheduleDetailController *detailView;

@end
