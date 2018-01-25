//
//  SettingsViewC.h
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewC : GAITrackedViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


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
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *offLaebl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *onLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgContainerView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) UIImagePickerController *picker;

- (IBAction)syncButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;

- (IBAction)wordSliderValueChanged:(id)sender;
- (IBAction)testDefaultButtonClicked:(id)sender;
- (IBAction)updateButtonClicked:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)soundSliderValueChanged:(id)sender;

@end
