//
//  SessionManager.h
//  httpSync
//
//  Created by Abby Schlageter on 06/05/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject

+(NSURLSession*)sessionWithDelegate:(id)delegate;

@end
