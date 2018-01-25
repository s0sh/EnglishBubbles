//
//  AddNewWord.m
//  WordBucket
//
//  Created by ashish on 4/18/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "AddNewWord.h"

@implementation AddNewWord


// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    
    NSLog(@"file type is %@",self.fileURL);
    if ([contents length] > 0) {
        self.addedWord = [[NSString alloc] initWithBytes:[contents bytes]
                                                    length:[contents length]
                                                  encoding:NSUTF8StringEncoding];
        //NSLog(@"content array is %@",self.addedWord);
        
    } else {
        
        self.addedWord = [Common setLanguageOniCloudFile];; // When the note is created we assign some default content
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newWordAdded"
                                                       object:self];
    
    return YES;
    
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([self.addedWord length] == 0) {
        self.addedWord = [Common setLanguageOniCloudFile];;
    }
    
    return [self.addedWord dataUsingEncoding:NSUTF8StringEncoding];
    
}

@end
