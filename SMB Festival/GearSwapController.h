//
//  GearSwapController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/12/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FestivalInfoViewController.h"

@interface GearSwapController : FestivalInfoViewController {
    UIScrollView *scroll;
    UIView *page;
}

@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) IBOutlet UIView *page;

@end
