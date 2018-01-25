//
//  LearnEngTGameViewC.h
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnEngTGameViewC : GAITrackedViewController



@property (unsafe_unretained, nonatomic) IBOutlet UITextView *detailTextView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnTryFreeClass;


- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)soundsCoolButtonClicked:(id)sender;

@end
