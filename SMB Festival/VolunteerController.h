//
//  VolunteerControll.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/12/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FestivalInfoViewController.h"
#import "VolunteerWebController.h"

@interface VolunteerController : FestivalInfoViewController {
    VolunteerWebController *webController;
    UIButton *button;
}

@property (nonatomic,retain) VolunteerWebController *webController;
@property (nonatomic,retain) IBOutlet UIButton *button;

- (IBAction)buttonPressed:(id)sender;

@end
