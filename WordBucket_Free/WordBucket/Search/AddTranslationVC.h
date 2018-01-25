//
//  AddTranslationVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 1/24/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "CustomTextField.h"
#import <iAd/iAD.h>

@interface AddTranslationVC : GAITrackedViewController<ActionSheetDelegate,PickerDelegate,UIActionSheetDelegate,ADBannerViewDelegate>
{
}
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtSearchWord;
@property(nonatomic,strong) NSString *strSearchedWord;
@property(nonatomic,strong) IBOutlet CustomTextField *txtTranslation;
@property(nonatomic,strong) IBOutlet UIButton *btnShare;
@property(nonatomic,strong) IBOutlet UIButton *btnAddTrans;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *yourTranslatioinLbl;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;

- (void)addBannerView;
-(IBAction)share:(id)sender;
-(IBAction)addTranslation:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;



@end
