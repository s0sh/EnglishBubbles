//
//  DBHelper.h
//  WeddingVenue
//
//  Created by Mehak Bhutani on 11/19/12.
//  Copyright (c) 2012 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppDelegate.h"
@interface DBHelper : NSObject
{
    sqlite3 *wordBucketDB;
}
-(NSMutableArray *) fetchRecordFromDB:(NSString *)tableName withField:(NSString *)field;
- (NSInteger) getRowCountWithQuery:(NSString*)queryString;
-(void) deleteRecordIntoTableNamed:(NSString *)tableName;
-(void) updateRecordIntoTableNamed:(NSString *)tableName;
-(NSString *) insertRecordIntoTableNamed:(NSString *)tableName withField:(NSString *)field fieldValue:(NSString*)fieldValue;
+(DBHelper *) sharedDbInstance;
-(NSString *) insertMultipleRows:(NSString *)sqlQuery;
- (NSString*)getSingleStringWithQuery:(NSString*)queryString;
- (NSMutableArray*)getAllValuesFromDictionaryTable:(NSString*)queryString;
@end
