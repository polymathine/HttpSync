//
//  ServerUpload.m
//  httpSync
//
//  Created by Abby Schlageter on 22/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "ServerUpload.h"
#import "Database.h"
#import "HTTPRequest+Body.h"
#import "HTTPRequest.h"
#import "SessionManager.h"

@interface ServerUpload ()
@property (nonatomic, strong) NSURLSession *uploadSession;
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@end

@implementation ServerUpload
-(void)uploadDatabaseWithUsername:(NSString*)theUsername andPassword:(NSString*)thePassword
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL, UPLOAD]];
    NSLog(@"upload URL = %@", url);
    
    //path for database in phone to upload to server
    NSString *targetPath = [Database getPathToDatabaseInDirectory];
    NSData *fileData = [NSData dataWithContentsOfFile:targetPath];
    NSString *boundary = @"OUR_BOUNDARY_STRING";
    NSData *data = [HTTPRequest createBodyWithBoundary:boundary username:theUsername password:thePassword data:fileData filename:[targetPath lastPathComponent]];
    
        //create request
    NSMutableURLRequest *request = [HTTPRequest requestWithData:fileData andURL:url andUsername:theUsername andPassword:thePassword andFilename:[targetPath lastPathComponent]];
    
    [self doUploadWithRequest:request andData:data];
}


-(void)doUploadWithRequest:(NSMutableURLRequest*)request andData:(NSData*)data
{
    //create session and upload task using both delegate for upload progress feedback and completion handler block to report any errors
    self.uploadSession = [SessionManager sessionWithDelegate:self];
    
    self.uploadTask = [self.uploadSession uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Response:%@ %@\n", response, error);
        if(error == nil)
        {
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
            
            if ([text isEqualToString:@"Success"])
            {
                NSLog(@"upload successful, can now continue to download");
            }
            else
            {
                NSLog(@"there was a problem with the upload data going into the server");
            }
        }
        else{
            NSLog(@"error connecting to server");
        }
    }];
    [self.uploadTask resume];
}

    


//task/upload delegate methods
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"Sent: %lld bytes (Uploaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesSent, totalBytesSent, totalBytesExpectedToSend);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{

}



@end
