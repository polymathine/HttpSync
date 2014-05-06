//
//  HTTPRequest+Body.h
//  httpSync
//
//  Created by Abby Schlageter on 06/05/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (Body)

+ (NSData *) createBodyWithBoundary:(NSString *)boundary username:(NSString*)username password:(NSString*)password data:(NSData*)data filename:(NSString *)filename;

@end
