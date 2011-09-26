//
//  DownloadController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/24/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "DownloadController.h"

#define kDataFilename @"offline-sources.plist"

@implementation DownloadController
@synthesize progressView;
@synthesize sourceIndexPath;
@synthesize downloadName, downloadSize;
@synthesize sourceLabel;
@synthesize sourceName;
@synthesize sourceSize;
@synthesize sourceURL;
@synthesize sourceFilename;
@synthesize theRequest;
@synthesize maplist;
@synthesize downloadDescription, sourceDescription;

- (void) dealloc {
    [super dealloc];
    [progressView release];
    [sourceIndexPath release];
    [downloadName release];
    [downloadSize release];
    [sourceLabel release];
    [sourceName  release];
    [sourceSize release];
    [sourceFilename release];
    [sourceURL release];
    [theRequest release];
    [maplist release];
    [downloadDescription release];
    [sourceDescription release];
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

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kDataFilename];
}

- (void) loadOfflineMapData {
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // data file exists, so just read it
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        NSMutableArray *data = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
        self.maplist = data;
        [data release];
        [array release];
    }
    else {
        // no data file yet, so init from the template in our resource bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Maps" ofType:@"plist"];
        NSArray *array = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"Root"];
        NSMutableArray *data = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
        self.maplist = data;
        [data release];
        [array release];
    }
}

- (void) saveOfflineMapData {
    [maplist writeToFile:[self dataFilePath] atomically:YES];
}

- (void)cancelDownload {
    NSLog(@"download cancelled");
    // save the tmp file and cancel the download
    NSString *tmpPath = [theRequest temporaryFileDownloadPath];
    [theRequest clearDelegatesAndCancel];
    
    // cleanup tmp file
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:&error];
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:[error localizedDescription]
                              message:[error localizedFailureReason]
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Downloading";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    progressView.backgroundColor = [UIColor clearColor];
    downloadDescription.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDownload)];
    self.navigationItem.leftBarButtonItem = cancel;
    [cancel release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.downloadName.text = [NSString stringWithFormat:@"Downloading %@ - %@",
                              sourceLabel,sourceName];
    self.downloadSize.text = [NSString stringWithFormat:@"Total download size is %@",
                              sourceSize];
    self.downloadDescription.text = sourceDescription;
    
    // start the download
    NSURL *url = [NSURL URLWithString:sourceURL];
    self.theRequest = [ASIHTTPRequest requestWithURL:url];
    [theRequest setDelegate:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:sourceFilename];
    [theRequest setDownloadDestinationPath:filename];
    
    [theRequest setDownloadProgressDelegate:progressView];
    [theRequest startAsynchronous];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.progressView = nil;
    self.sourceIndexPath = nil;
    self.downloadSize = nil;
    self.downloadName = nil;
    self.sourceLabel = nil;
    self.sourceName = nil;
    self.sourceSize = nil;
    self.sourceURL = nil;
    self.sourceFilename = nil;
    self.theRequest = nil;
    self.maplist = nil;
    self.sourceDescription = nil;
    self.downloadDescription = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ASIHttpRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request {
    // get the current source data
    [self loadOfflineMapData];
    
    // replace the old source with the new updates
    // we want to mark the item just downloaded as downloaded and enabled, and then disable any other items
    NSMutableArray *sources = [[[maplist objectAtIndex:[sourceIndexPath section]] objectForKey:@"Maps"] mutableCopy];
    for (int ii=0; ii < [sources count]; ii++) {
        NSDictionary *source = [[[maplist objectAtIndex:[sourceIndexPath section]] objectForKey:@"Maps"] objectAtIndex:ii];
        NSMutableDictionary *newSource = [[NSMutableDictionary alloc] initWithDictionary:source];
        
        if (ii == [sourceIndexPath row]) {
            [newSource setValue:[NSNumber numberWithBool:YES] forKey:@"Downloaded"];
            [newSource setValue:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
        }
        else {
            [newSource setValue:[NSNumber numberWithBool:NO] forKey:@"Enabled"];
        }
        
        [sources replaceObjectAtIndex:ii withObject:newSource];
        [newSource release];
    }
    
    // now that our sources is setup how we want them to be, we replace them in the "Maps" key for the section data
    NSMutableDictionary *maps = [[maplist objectAtIndex:[sourceIndexPath section]] mutableCopy];
    [maps setValue:sources forKey:@"Maps"];

    // finally we replace the section data in the maps list
    [maplist replaceObjectAtIndex:[sourceIndexPath section] withObject:maps];
    
    [sources release];
    [maps release];

    // save our data and pop back to the previous controller
    [self saveOfflineMapData];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:[error localizedDescription]
                          message:[error localizedFailureReason]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
