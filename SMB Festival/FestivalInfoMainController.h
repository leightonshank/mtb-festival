//
//  FestivalInfo.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/8/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutController.h"

@interface FestivalInfoMainController : UIViewController
    <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *sections;
    UITableView *infoTable;
    
    AboutController *aboutController;
    UIButton *infoButton;
}

@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) IBOutlet UITableView *infoTable;
@property (nonatomic,retain) AboutController *aboutController;
@property (nonatomic,retain) IBOutlet UIButton *infoButton;

- (IBAction)infoButtonPressed:(id)sender;

@end
