//
//  NSMutableArray+Shuffling.m
//  WordBucket
//
//  Created by ashish on 2/15/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    for (uint i = 0; i < self.count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = self.count - i;
        int n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}



// Remove all dublicate values from array
- (void)removeDublicateObjects
{
    
    NSArray *copy = [self copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([self indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [self removeObjectAtIndex:index];
        }
        index--;
    }
}

@end
