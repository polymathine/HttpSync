//
//  HTTPRequest.m
//  httpSync
//
//  Created by Abby Schlageter on 06/05/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "HTTPRequest.h"
#import "HTTPRequestBody.h"

@interface HTTPRequest ()

@property (nonatomic, retain) HTTPRequestBody *httpBody;

@end

@implementation HTTPRequest

+(NSMutableURLRequest*)requestWithData:(NSData*)data andURL:(NSURL*)url andUsername:(NSString*)theUsername andPassword:(NSString*)thePassword andFilename:(NSString*)theFilename
{
//create http request
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
[request setHTTPMethod:@"POST"];
NSString *boundary = @"OUR_BOUNDARY_STRING";
[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
NSData *body = [HTTPRequestBody createBodyWithBoundary:boundary username:theUsername password:thePassword data:Nil filename:Nil];
[request setHTTPBody:body];
    
    return request;
}

@end
