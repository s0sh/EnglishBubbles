//
//  ProgressView.h
//  WordBucket
//
//  Created by ashish on 3/13/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
@property (nonatomic, assign) NSInteger percent;
@property (nonatomic, assign) CGFloat increament;

- (id)initWithFrame:(CGRect)frame isSmallSize:(BOOL)isSmall;

@end
