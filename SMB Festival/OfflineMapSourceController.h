//
//  OfflineMapSourceController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/23/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineMapSourceController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *maplist;
    UITableView *table;
}

@property (nonatomic,retain) NSArray *maplist;
@property (nonatomic,retain) IBOutlet UITableView *table;

@end
