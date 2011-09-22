//
//  RegistrationController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/10/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FestivalInfoViewController.h"
#import "RegistrationWebController.h"

@interface RegistrationController : FestivalInfoViewController {
    UIScrollView *scroll;
    UIView *page;
    
    RegistrationWebController *webController;
    UIButton *button;
}

@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) IBOutlet UIView *page;
@property (nonatomic,retain) IBOutlet UIButton *button;

@property (nonatomic,retain) RegistrationWebController *webController;

- (IBAction)buttonPressed:(id)sender;

@end
