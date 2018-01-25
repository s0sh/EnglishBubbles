//
//  CustomTextField.m
//  RIMNew
//
//  Created by DINNY SINGH on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTextField.h"


@implementation CustomTextField
@synthesize verticalPadding,horizontalPadding;
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + horizontalPadding, bounds.origin.y+verticalPadding, bounds.size.width - horizontalPadding, bounds.size.height);
	return inset;
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + horizontalPadding, bounds.origin.y+verticalPadding, bounds.size.width - horizontalPadding, bounds.size.height);
	return inset;
}

@end
