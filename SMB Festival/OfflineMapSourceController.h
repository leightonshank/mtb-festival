//
//  OfflineMapSourceController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/23/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownloadController;

@interface OfflineMapSourceController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *maplist;
    UITableView *table;
    
    DownloadController *downloadController;
}

@property (nonatomic,retain) NSMutableArray *maplist;
@property (nonatomic,retain) IBOutlet UITableView *table;
@property (nonatomic,retain) DownloadController *downloadController;

@end
