//
//  ServerDownload.m
//  httpSync
//
//  Created by Abby Schlageter on 15/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "ServerDownload.h"
#import <sqlite3.h>
#import "Database.h"
#import "Constants.h"
#import "HTTPRequest.h"
#import "SessionManager.h"

@interface ServerDownload ()

@property (nonatomic, strong) NSURLSession *downloadSession;
@property (nonatomic, strong) NSURLSessionDataTask *dataURLTask;
@property (nonatomic, retain) NSString *downloadURL;
@property (nonatomic, strong) NSURLSessionDownloadTask *dwnldTask;
@property (nonatomic) sqlite3 *mainDB;
@end

@implementation ServerDownload

-(void)getDownloadURLWithUsername:(NSString*)theUsername andPassword:(NSString*)thePassword andExtension:(NSString*)theExtension
{
    //url that will give the location (url) of the new database to download
    NSString *basicURL = [NSString stringWithFormat:@"%@", URL];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", URL, theExtension];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //create http request
    NSMutableURLRequest *request = [HTTPRequest requestWithData:Nil andURL:url andUsername:theUsername andPassword:thePassword andFilename:Nil];
    
    //set up NSURLSession for retrieving data task
    self.downloadSession = [SessionManager sessionWithDelegate:self];
    self.dataURLTask = [self.downloadSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                        {
                            if(error == nil)
                            {
                                //add retrieved download location info to the basicURL
                                NSString *text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                self.downloadURL = [NSString stringWithFormat:@"%@%@", basicURL, text];
                                NSLog(@"download URL:%@", self.downloadURL);
                                //download database from url
                                [self downloadDatabaseFromUrl];
                            }
                            else
                            {
                                //unable to retrieve location url of database to download from server
                                NSLog(@"unable to retrieve location url of database to download from server due to error %@", error.description);
                            }
                        }];
    [self.dataURLTask resume];
    
}

-(void)downloadDatabaseFromUrl
{
    //url to download from
    NSURL *url = [NSURL URLWithString:self.downloadURL];
    self.dwnldTask = [self.downloadSession downloadTaskWithURL:url];
    
    [self.dwnldTask resume];
}

#pragma mark Download Delegates
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *recievedData = [NSData dataWithContentsOfURL:location];
    NSString *databasePath = [Database getPathToDatabaseInDirectory];
    
    //downloaded data automatically stored in temporary file at location
    NSLog(@"Temporary File :%@\n", location);
    NSError *err = nil;
    
    //copy data to database at databasePath on phone
    if ([[NSFileManager defaultManager] createFileAtPath:databasePath contents:recievedData attributes:nil])
    {
        NSLog(@"succesfully copied database from server download to phone");
        Database *theDatabase = [[Database sharedInstance] init];
        self.mainDB = [theDatabase retrieveDatabase];
        [self getFromDatabase:self.mainDB];
    }
    else
    {
        NSLog(@"failed to copy database to phone: %@",[err userInfo]);
    }
}


//test for database table names
-(void)getFromDatabase:(sqlite3*)theDatabase
{
    //pointer to final outcome from database query, called statement
    sqlite3_stmt    *statement;
    
    NSString *querySQL =[NSString stringWithFormat: @"SELECT name FROM sqlite_master WHERE type = \'table\'"];
    
    if (sqlite3_prepare_v2(theDatabase, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        NSMutableArray *selectedRecords = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *value = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0)
                                                 encoding:NSUTF8StringEncoding];
            NSLog(@"value = %@", value);
            [selectedRecords addObject:value];
            
            
        }
        sqlite3_finalize(statement);
    }
    else NSLog(@"sqlite query not implemented because %s", sqlite3_errmsg(theDatabase));
    
}


@end
