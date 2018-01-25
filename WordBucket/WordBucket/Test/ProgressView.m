//
//  ProgressView.m
//  WordBucket
//
//  Created by ashish on 3/13/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "ProgressView.h"

#define kCircleSegs 10

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame isSmallSize:(BOOL)isSmall
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (isSmall) {
            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"timerja.png"]]];
        } else {
            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"timer.png"]]];
        }
        _increament = 1;

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = CGRectGetWidth(rect)/2.0f - 3.0/2.0f;
    float angleOffset = M_PI_2;
    
    CGContextSetLineWidth(context, 3.0);
    CGContextBeginPath(context);
    CGContextAddArc(context,CGRectGetMidX(rect), CGRectGetMidY(rect),radius,-angleOffset,
                        (_increament/(float)_percent)*M_PI*2 - angleOffset,0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 3.0f);
}


@end
