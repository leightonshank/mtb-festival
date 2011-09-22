//
//  RegistrationWebController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/10/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationWebController : UIViewController 
    <UIWebViewDelegate, UIAlertViewDelegate> 
{
    UIWebView *web;
    UIView *loading;
}

@property (nonatomic,retain) IBOutlet UIWebView *web;
@property (nonatomic,retain) IBOutlet UIView *loading;

- (void)loadPage;

@end
