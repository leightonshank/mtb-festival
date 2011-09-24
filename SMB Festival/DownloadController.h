//
//  DownloadController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/24/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadController : UIViewController {
    UIProgressView *progressView;
    NSDictionary *source;
    NSString *sectionLabel;
    
    UILabel *downloadName;
    UILabel *downloadSize;
}

@property (nonatomic,retain) IBOutlet UIProgressView *progressView;
@property (nonatomic,retain) NSDictionary *source;
@property (nonatomic,retain) NSString *sectionLabel;
@property (nonatomic,retain) IBOutlet UILabel *downloadName;
@property (nonatomic,retain) IBOutlet UILabel *downloadSize;

@end
