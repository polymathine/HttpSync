//
//  Database.h
//  httpSync
//
//  Created by Abby Schlageter on 15/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject

@property (nonatomic) sqlite3 *mainDB;

+(Database*)sharedInstance;
+(NSString*)getPathToDatabaseInDirectory;
-(sqlite3*)retrieveDatabase;

@end
