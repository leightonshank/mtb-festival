//
//  GeneralInfoController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/9/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FestivalInfoViewController.h"

@interface GeneralInfoController : FestivalInfoViewController {
    UIScrollView *scroll;
    UIView *page1;
}

@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) IBOutlet UIView *page1;

@end
