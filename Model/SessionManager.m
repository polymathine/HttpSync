//
//  SessionManager.m
//  httpSync
//
//  Created by Abby Schlageter on 06/05/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

+(NSURLSession*)sessionWithDelegate:(id)delegate
{
//set up NSURLSession for retrieving data task
NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
defaultConfigObject.HTTPMaximumConnectionsPerHost = 1;
NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:delegate delegateQueue:Nil];
    
    return session;
}
@end
