//
//  WordList.m
//  WordBucket
//
//  Created by ashish on 4/17/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "WordList.h"

@implementation WordList

// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"file type is %@",self.fileURL);
    
    if ([contents length] > 0) {
        self.noteContent = [[NSString alloc] initWithBytes:[contents bytes]
                                                    length:[contents length]
                                                  encoding:NSUTF8StringEncoding];
        
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSMutableArray *plistArray = (NSMutableArray*)[NSPropertyListSerialization propertyListFromData:contents mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        
        if(!plistArray){
            
            NSLog(@"Error: %@",errorDesc);
            
        } else {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *dbPath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:kWordPlist];
            NSLog(@"%@",dbPath);
            if(![fileManager fileExistsAtPath:dbPath])
            {
                [plistArray writeToFile:dbPath atomically:YES];
            } else {
                NSLog(@"file already exist");
            }
        }
        
        
        
    } else {
        self.noteContent = @"Empty"; // When the note is created we assign some default content
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upgradeWord"
                                                        object:self];
    
    return YES;
    
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([self.noteContent length] == 0) {
        self.noteContent = @"Empty";
    }
    
    return [NSData dataWithBytes:[self.noteContent UTF8String]
                          length:[self.noteContent length]];
    
}

@end
