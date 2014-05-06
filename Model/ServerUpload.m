//
//  ServerUpload.m
//  httpSync
//
//  Created by Abby Schlageter on 22/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "ServerUpload.h"
#import "Database.h"
#import "HTTPRequestBody.h"
#import "HTTPRequest.h"
#import "SessionManager.h"

@interface ServerUpload ()
@property (nonatomic, strong) NSURLSession *uploadSession;
@property (nonatomic, retain) HTTPRequestBody *httpBody;
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@end
@implementation ServerUpload

-(void)uploadDatabaseWithUsername:(NSString*)theUsername andPassword:(NSString*)thePassword
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", URL, UPLOAD];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"upload URL = %@", urlString);
    
    //path for database in phone to upload to server
    NSString *targetPath = [Database getPathToDatabaseInDirectory];
    
    //create request
   /* NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];*/
    

    
    
    //create session and upload task using both delegate for upload progress feedback and completion handler block to report any errors as well as continue with download once completed upload succesfully
    /*
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = 1;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:Nil];
    self.uploadSession = session;*/
    self.uploadSession = [SessionManager sessionWithDelegate:self];
    
    NSData *fileData = [NSData dataWithContentsOfFile:targetPath];
    NSString *boundary = @"OUR_BOUNDARY_STRING";
    NSData *data = [HTTPRequestBody createBodyWithBoundary:boundary username:theUsername password:thePassword data:fileData filename:[targetPath lastPathComponent]];
    
    NSMutableURLRequest *request = [HTTPRequest requestWithData:fileData andURL:url andUsername:theUsername andPassword:thePassword andFilename:[targetPath lastPathComponent]];
    
    //CHANGED THIS FROM SESSIONS TO SELF>UPLOADSESSION
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
    //NSAssert(!error, @"%s: uploadTaskWithRequest error: %@", __FUNCTION__, error);

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