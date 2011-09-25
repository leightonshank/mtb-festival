//
//  DownloadController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/24/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface DownloadController : UIViewController
    <ASIHTTPRequestDelegate>
{
    UIProgressView *progressView;
    
    NSIndexPath *sourceIndexPath;
    
    NSString *sourceLabel;
    NSString *sourceName;
    NSString *sourceSize;
    NSString *sourceURL;
    NSString *sourceFilename;
    
    UILabel *downloadName;
    UILabel *downloadSize;
    
    ASIHTTPRequest *theRequest;
    
    NSMutableArray *maplist;
}

@property (nonatomic,retain) IBOutlet UIProgressView *progressView;
@property (nonatomic,retain) NSIndexPath *sourceIndexPath;
@property (nonatomic,retain) NSString *sourceLabel;
@property (nonatomic,retain) NSString *sourceName;
@property (nonatomic,retain) NSString *sourceSize;
@property (nonatomic,retain) NSString *sourceURL;
@property (nonatomic,retain) NSString *sourceFilename;
@property (nonatomic,retain) IBOutlet UILabel *downloadName;
@property (nonatomic,retain) IBOutlet UILabel *downloadSize;
@property (nonatomic,retain) ASIHTTPRequest *theRequest;
@property (nonatomic,retain) NSMutableArray *maplist;

@end
