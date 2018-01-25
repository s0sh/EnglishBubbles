//
//  UIView+Utilities.m
//  WordBucket
//
//  Created by Ashish on 30/07/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "UIView+Utilities.h"

@implementation UIView (Utilities)

- (void)movewViewUp
{
    
//    [UIView beginAnimations:@"registerScroll" context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.4];
//    self.transform = CGAffineTransformMakeTranslation(0, 30);
//    [UIView commitAnimations];
    
    if (self.frame.origin.y == 0 && !SharedAppDelegate.isPhone5) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        CGRect frame = self.frame;
        frame.origin.y = - 12;
        NSLog(@"frame is %@",NSStringFromCGRect(frame));
        [self setFrame:frame];
        [UIView commitAnimations];
    }
    
}

- (void)movewViewDown
{
    //if (self.frame.origin.y != 0) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    CGRect frame = self.frame;
    frame.origin.y = 0;
    [self setFrame:frame];
    [UIView commitAnimations];
    //}
}


@end
