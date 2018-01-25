//
//  TimerView.m
//  WordBucket
//
//  Created by ashish on 2/21/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "TimerView.h"

@implementation TimerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"timer.png"]]];
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = CGRectGetWidth(rect)/2.0f - 3.0/2.0f;
    float angleOffset = M_PI_2;
    
    CGContextSetLineWidth(context, 3.0);
    CGContextBeginPath(context);
    CGContextAddArc(context,CGRectGetMidX(rect), CGRectGetMidY(rect),radius,-angleOffset,
                    ((45.0-_percent)/45.0)*M_PI*2 - angleOffset,0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 3.0f);
    
    
    NSString* textContent = [NSString stringWithFormat:@"%d", self.percent];
    
    //UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    // Create our arc, with the correct angles
    //[bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
    //                      radius:130
    //                  startAngle:startAngle
    //                    endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
    //                   clockwise:YES];
    
    // Set the display for the path, and stroke it
    //bezierPath.lineWidth = 20;
    //[[UIColor redColor] setStroke];
    //[bezierPath stroke];
    
    // Text Drawing
    CGRect textRect = CGRectMake(0, 12, 60, 60);
    //CGRect textRect = rect;
    [[UIColor blackColor] setFill];
    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica" size: 26] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
     
     
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
