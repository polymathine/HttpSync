//
//  httpViewController.m
//  httpSync
//
//  Created by Abby Schlageter on 12/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "httpViewController.h"
#import "ServerDownload.h"
#import "ServerUpload.h"

@interface httpViewController ()
@property (strong, nonatomic) IBOutlet UIButton *dwnldCleanButton;
@property (nonatomic, retain) ServerDownload *syncsDownload;
@property (nonatomic, retain) ServerUpload *syncsUpload;
@property (strong, nonatomic) IBOutlet UIButton *dwnldButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@end

@implementation httpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.syncsDownload = [[ServerDownload alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)downloadClean:(id)sender
{
    [ServerDownload setUpDownloadURLRequestWithUsername:USERNAME andPassword:PASSWORD andExtension:EXTENSION_CLEAN];
}

-(IBAction)download:(id)sender
{
    [ServerDownload setUpDownloadURLRequestWithUsername:USERNAME andPassword:PASSWORD andExtension:EXTENSION];
}

-(IBAction)upload:(id)sender
{
    [self.syncsUpload uploadDatabaseWithUsername:USERNAME andPassword:PASSWORD];
}

@end
