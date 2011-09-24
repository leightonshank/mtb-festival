//
//  DownloadController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/24/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "DownloadController.h"

@implementation DownloadController
@synthesize progressView;
@synthesize source;
@synthesize downloadName, downloadSize;
@synthesize sectionLabel;

- (void) dealloc {
    [super dealloc];
    [progressView release];
    [source release];
    [downloadName release];
    [downloadSize release];
    [sectionLabel release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)cancelDownload {
    NSLog(@"download cancelled");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Downloading";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDownload)];
    self.navigationItem.leftBarButtonItem = cancel;
    [cancel release];
    
    self.downloadName.text = [NSString stringWithFormat:@"Downloading %@ - %@",
                              sectionLabel,
                              [source objectForKey:@"Name"]];
    self.downloadSize.text = [NSString stringWithFormat:@"Total size is %@",
                              [source objectForKey:@"Filesize"]];
    
    // start the download
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.progressView = nil;
    self.source = nil;
    self.downloadSize = nil;
    self.downloadName = nil;
    self.sectionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
