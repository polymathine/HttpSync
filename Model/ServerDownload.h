//
//  ServerDownload.h
//  httpSync
//
//  Created by Abby Schlageter on 15/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerDownload : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

+(void)setUpDownloadURLRequestWithUsername:(NSString*)username andPassword:(NSString*)password andExtension:(NSString*)extension;


@end
