//
//  FestivalInfo.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/8/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestivalInfoMainController : UIViewController
    <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *sections;
    UITableView *infoTable;
    UIView *titleView;
}

@property (nonatomic,retain) NSArray *sections;
@property (nonatomic,retain) IBOutlet UITableView *infoTable;
@property (nonatomic,retain) IBOutlet UIView *titleView;

@end
