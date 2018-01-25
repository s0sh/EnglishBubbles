//
//  DBHelper.m
//  WeddingVenue
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 TechAhead. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper
//select records from particular table
static DBHelper *objHelper = nil;
+(DBHelper *) sharedDbInstance
{
    if(!objHelper)
        objHelper = [[DBHelper alloc] init];
    
    return objHelper;
    
}

-(NSMutableArray *) fetchRecordFromDB:(NSString *)tableName withField:(NSString *)field
{
    AppDelegate *delegate = [[AppDelegate alloc] init];
    wordBucketDB = [delegate getNewDBConnection];
	
	NSMutableArray *fieldValue = [[NSMutableArray alloc] init] ;
	
	sqlite3_stmt  *statement;
	
	NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@",field,tableName];
    //NSLog(@"query string is %@",querySQL);
	const char *query_stmt = [querySQL UTF8String];
	
	if (sqlite3_prepare_v2(wordBucketDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
	{
		
		NSInteger index=0;
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			NSArray *fieldCount = [field componentsSeparatedByString:@","];
			NSString *nameField = @"";
			for (int i=0; i<[fieldCount count]; i++)
			{
                const char* field = (const char*)sqlite3_column_text(statement, i);
                nameField = field == NULL ? [NSString stringWithFormat:@"|%@",@""] : [nameField stringByAppendingPathComponent:[NSString stringWithFormat: @"|%@",[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)] ]];
                
                
			}
			if (![nameField isEqualToString:@""]) {
                int end=[nameField length]; 
                nameField=[nameField substringWithRange:NSMakeRange(1, end-1)];
            }
			
			[fieldValue insertObject:nameField atIndex:index];
			index++;
		}
		
	}
	sqlite3_finalize(statement);
	return fieldValue;
}


/*
- (NSMutableArray *)fetchMeaningOfExistingWordWithQuery:(NSString*)querySQL
{
    
    
    AppDelegate *delegate = [[AppDelegate alloc] init];
    wordBucketDB = [delegate getNewDBConnection];
	
	NSMutableArray *fieldValue = [[NSMutableArray alloc] init] ;
	
	sqlite3_stmt  *statement;
	
	//NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@",field,tableName];
    NSLog(@"query string is %@",querySQL);
	const char *query_stmt = [querySQL UTF8String];
	
	if (sqlite3_prepare_v2(wordBucketDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
	{
		
		NSInteger index=0;
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			NSArray *fieldCount = [field componentsSeparatedByString:@","];
			NSString *nameField = @"";
			for (int i=0; i<[fieldCount count]; i++)
			{
                const char* field = (const char*)sqlite3_column_text(statement, i);
                nameField = field == NULL ? [NSString stringWithFormat:@"|%@",@""] : [nameField stringByAppendingPathComponent:[NSString stringWithFormat: @"|%@",[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)] ]];
                
                
			}
			if (![nameField isEqualToString:@""]) {
                int end=[nameField length];
                nameField=[nameField substringWithRange:NSMakeRange(1, end-1)];
            }
			
			[fieldValue insertObject:nameField atIndex:index];
			index++;
		}
		
	}
	sqlite3_finalize(statement);
	return fieldValue;
     
}
*/

- (NSString*)getSingleStringWithQuery:(NSString*)queryString
{
    
    NSString *nameField = nil;
    sqlite3_stmt  *statement;
    
    //NSLog(@"query string = %@",queryString);
	
	const char *query_stmt = [queryString UTF8String];
    if (sqlite3_prepare_v2(wordBucketDB, query_stmt, -1, &statement, NULL) != SQLITE_OK)
	{
        NSAssert1(0,@"error preparing statement",sqlite3_errmsg(wordBucketDB));
        
    } else {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            const char* field = (const char*)sqlite3_column_text(statement, 0);
            //nameField =  field == NULL ? @"" : [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)];
            nameField = field == NULL ? @"" : [NSString stringWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            
        }
    }
    
    sqlite3_finalize(statement);
    return nameField;
    
}


- (NSInteger) getRowCountWithQuery:(NSString*)queryString
{
    
    NSInteger count;
    sqlite3_stmt  *statement;
	
	const char *query_stmt = [queryString UTF8String];
    if (sqlite3_prepare_v2(wordBucketDB, query_stmt, -1, &statement, NULL) != SQLITE_OK)
	{
        
        count = 0;
        NSAssert1(0,@"error preparing statement",sqlite3_errmsg(wordBucketDB));
        
    } else {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            count = sqlite3_column_int(statement, 0);
            NSLog(@"count = %d",count);
        }
    }
    
    sqlite3_finalize(statement);
    return count;
    
    
}

- (NSMutableArray*)getAllValuesFromDictionaryTable:(NSString*)queryString
{
    
    NSMutableArray *wordArray = [[NSMutableArray alloc] init];
    sqlite3_stmt  *statement;
	
	const char *query_stmt = [queryString UTF8String];
    if (sqlite3_prepare_v2(wordBucketDB, query_stmt, -1, &statement, NULL) != SQLITE_OK)
	{
        
        NSAssert1(0,@"error preparing statement",sqlite3_errmsg(wordBucketDB));
        
    } else {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            const char* field = (const char*)sqlite3_column_text(statement, 8);
            NSString *dateString = field == NULL ? @"" : [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,8)];
            
            
            NSMutableDictionary* aDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)],kId,
            [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)],kTargetWord,
            [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)],kNativeWord,
            [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)],kBucketColor,
            [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)],kNativeLanguage,
            [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)],kTargetLanguage,
            [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)],kAction,
            [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)],kUserLevel,
            dateString,kdateOfTest,[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)],ksense,[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)],kPOS,
            nil];
            [wordArray addObject:aDict];
            //count = sqlite3_column_int(statement, 0);
        }
    }
    
    sqlite3_finalize(statement);
    return wordArray;
    
}


//insert records into table

-(NSString *) insertRecordIntoTableNamed:(NSString *)tableName withField:(NSString *)field fieldValue:(NSString*)fieldValue
{
    if(!wordBucketDB)
    {
        AppDelegate *delegate = [[AppDelegate alloc] init];
        wordBucketDB = [delegate getNewDBConnection];
    }
    NSString *rowId=@"";
    
        sqlite3_stmt  *statement;
                
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO  %@ ( %@ ) VALUES ( %@ )", tableName, field, fieldValue];
        
        //NSLog(@"%@",insertSQL);
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(wordBucketDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
            
        {
            
            //get row id of last inserted data
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT last_insert_rowid()"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            
            if (sqlite3_prepare_v2(wordBucketDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                
            {
                
                if (sqlite3_step(statement) == SQLITE_ROW)
                    
                {
                    
                    rowId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                }
                
            }
            
            NSLog(@"values inserted successfully");
            
            
        }
   
    return rowId;
    
    
    
}

-(NSString *) insertMultipleRows:(NSString *)sqlQuery
{
    if(!wordBucketDB)
    {
        AppDelegate *delegate = [[AppDelegate alloc] init];
        wordBucketDB = [delegate getNewDBConnection];
    }
    NSString *rowId=@"";
    
    sqlite3_stmt  *statement;
    
    NSString *insertSQL = sqlQuery;
    
    //NSLog(@"%@",insertSQL);
    
    const char *insert_stmt = [insertSQL UTF8String];
    
    sqlite3_prepare_v2(wordBucketDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        
        //get row id of last inserted data
        NSString *querySQL = [NSString stringWithFormat: @"SELECT last_insert_rowid()"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(wordBucketDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            
        {
            
            if (sqlite3_step(statement) == SQLITE_ROW)
                
            {
                rowId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
            
        }
        
        NSLog(@"values inserted successfully");
        
        
    }
    
    return rowId;
        
    
}


//update record from table
-(void) updateRecordIntoTableNamed:(NSString *)tableName

{
    sqlite3_stmt  *statement;
    
    NSString *insertSQL = [NSString stringWithFormat: @"UPDATE %@", tableName];
    
    //NSLog(@"UPDATE QUERY %@",insertSQL);
    
    const char *insert_stmt = [insertSQL UTF8String];
    
    sqlite3_prepare_v2(wordBucketDB, insert_stmt, -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_OK)
        
    {
        
        NSLog(@"updated");
        
    }
    
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(wordBucketDB));
        
    }
    
}


//delete record from table
-(void) deleteRecordIntoTableNamed:(NSString *)tableName
{
    sqlite3_stmt  *statement;
    
    
    NSString *insertSQL = [NSString stringWithFormat: @"DELETE FROM %@", tableName];
    
    //NSLog(@"%@",insertSQL);
    
    const char *insert_stmt = [insertSQL UTF8String];
    
    sqlite3_prepare_v2(wordBucketDB, insert_stmt, -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        
        NSLog(@"deleted");
        
    }
    
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(wordBucketDB));
        
    }
    
}
@end
