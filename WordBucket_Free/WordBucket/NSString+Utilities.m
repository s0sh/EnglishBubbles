//
//  NSString+Utilities.m
//  WordBucket
//
//  Created by ashish on 4/1/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewline{
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

@end
