//
//  HTTPRequestBody.h
//  httpSync
//
//  Created by Abby Schlageter on 12/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequestBody : NSObject

+ (NSData *) createBodyWithBoundary:(NSString *)boundary username:(NSString*)username password:(NSString*)password data:(NSData*)data filename:(NSString *)filename;

@end
