//
//  HTTPRequest.h
//  httpSync
//
//  Created by Abby Schlageter on 06/05/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequest : NSObject

+(NSMutableURLRequest*)requestWithData:(NSData*)data andURL:(NSURL*)url andUsername:(NSString*)theUsername andPassword:(NSString*)thePassword andFilename:(NSString*)theFilename;

@end
