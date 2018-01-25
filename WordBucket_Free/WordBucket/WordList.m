//
//  WordList.m
//  WordBucket
//
//  Created by ashish on 4/16/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "WordList.h"

@implementation WordList


// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([contents length] > 0) {
        self.noteContent = [[NSString alloc] initWithBytes:[contents bytes]
                                                    length:[contents length]
                                                  encoding:NSUTF8StringEncoding];
        NSLog(@"string is %@",self.noteContent);
        
    } else {
        self.noteContent = @"Empty"; // When the note is created we assign some default content
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified"
                                                        object:self];
    
    return YES;
    
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([self.noteContent length] == 0) {
        self.noteContent = @"Empty";
    }
    
    //return [NSData dataWithBytes:[self.noteContent UTF8String]
    //                      length:[self.noteContent length]];
    
    return [self.noteContent dataUsingEncoding:NSUTF8StringEncoding];
    
}



@end
