//
//  CreditViewC.h
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditViewC : GAITrackedViewController <UIWebViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)homeBucketClickd:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *wbsupportedbyTxt;
- (IBAction)englishButtonButtonClicked:(id)sender;

@end
