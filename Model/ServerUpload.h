//
//  ServerUpload.h
//  httpSync
//
//  Created by Abby Schlageter on 22/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerUpload : NSObject <NSURLSessionDelegate>

-(void)uploadDatabaseWithUsername:(NSString*)theUsername andPassword:(NSString*)thePassword;

@end
