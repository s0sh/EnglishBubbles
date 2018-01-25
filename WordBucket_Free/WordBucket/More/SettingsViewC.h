//
//  SettingsViewC.h
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAD.h>
#import "WordList.h"

@interface SettingsViewC : GAITrackedViewController<ADBannerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *onLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *settingsLbl;
@property (nonatomic, assign) NSInteger totalWords;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wordLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *wordSlider;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *soundButton;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *userNameTxtField;
- (IBAction)corssClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnDefaultTestWord;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *soundSettingLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *updateLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *totalWordLbl;
@property (assign, nonatomic) BOOL isBannerVisible;
@property (retain, nonatomic) ADBannerView *bannerView;
@property (strong) WordList * doc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) UIImagePickerController *picker;


- (IBAction)cameraButtonClicked:(id)sender;
- (void)addBannerView;
- (IBAction)syncButtonClicked:(id)sender;

- (IBAction)wordSliderValueChanged:(id)sender;
- (IBAction)testDefaultButtonClicked:(id)sender;
- (IBAction)updateButtonClicked:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)soundSliderValueChanged:(id)sender;

@end
