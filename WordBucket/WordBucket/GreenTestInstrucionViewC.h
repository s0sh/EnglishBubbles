//
//  GreenTestInstrucionViewC.h
//  WordBucket
//
//  Created by ashish on 3/19/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenTestInstrucionViewC : GAITrackedViewController

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bgImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *sixImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *fiveImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *fourImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *threeImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *twoImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *oneImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *turnLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dragLabel;

@property (nonatomic, retain) NSTimer *instrucionTimer;
@property (nonatomic, assign) BOOL isGreenTest;
@property (nonatomic, assign) NSInteger counter;

- (void)instrucionAction:(NSTimer *)timer;

@end
