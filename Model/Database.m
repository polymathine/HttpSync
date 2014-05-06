//
//  Database.m
//  httpSync
//
//  Created by Abby Schlageter on 15/04/2014.
//  Copyright (c) 2014 Abby Schlageter. All rights reserved.
//

#import "Database.h"
#import "Constants.h"

@implementation Database

//singleton method
+(Database*)sharedInstance
{
    static Database *_sharedInstance = nil;
    //ensures sharedInstance only created once
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate, ^{
        _sharedInstance = [[Database alloc] initFirstTime];
    });
    return _sharedInstance;
}

-(sqlite3*)retrieveDatabase
{
    return self.mainDB;
}

-(id) initFirstTime
{
    if ( (self = [super init]) )
    {
        //copy database file to iPhone directory
        NSString *databasePath = [Database getPathToDatabaseInDirectory];
    
        const char *dbPath = [databasePath UTF8String];
        sqlite3 *theDatabase;
        
        //if database opened succesfully at path, connection handle productDatabase
        if (sqlite3_open(dbPath, &theDatabase) == SQLITE_OK)
        {
            //database opened successfully
            NSLog(@"Database opened succesfully at path %@", databasePath);
        }
        else
        {
            NSLog(@"database not opened succesfully because %s", sqlite3_errmsg(theDatabase));
        }
        //assign sqliteDB parameter to sqlite3 property on Database Object
        self.mainDB = theDatabase;
    }
    return self;
}


+(NSString*)getPathToDatabaseInDirectory
{
    //get path to library folder on phone
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    //set up path to library where want ProductDatabase to be saved
    NSString *targetPath = [libraryPath stringByAppendingPathComponent:DB_FILENAME];
    return targetPath;
}



@end
