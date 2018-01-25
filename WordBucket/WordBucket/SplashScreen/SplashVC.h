//
//  SplashVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 11/27/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "NWPickerField.h"
#import "CustomTextField.h"
#import "GAITrackedViewController.h"

@interface SplashVC : GAITrackedViewController<PickerDelegate,NWPickerFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    
    //DBHelper *dbHelper;
    NWPickerField *activePickerField;
    UIImageView *imageAvatar;
    CustomTextField *txtName;
    NWPickerField *targetPickerField;
}


@property(nonatomic,strong) UIImageView *imageAvatar;
@property(nonatomic,strong) NWPickerField *targetPickerField;
@property(nonatomic,strong) NWPickerField *activePickerField;
@property(nonatomic,strong) CustomTextField *activeField;
@property(nonatomic,strong) IBOutlet UITableView *tblLanguageList;
@property(nonatomic,strong) IBOutlet UIButton *btnFinish;
@property(nonatomic,strong) NSArray *arrLanguages;
@property(nonatomic,strong) NSMutableArray *arrTargetLanguages;
@property(nonatomic,strong) NSArray *arrLabelText;
@property(nonatomic,strong) NSArray *arrUserLevel;
@property(nonatomic,strong) UIToolbar *toolbar;
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *termsAndCond;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;


-(IBAction)finish:(id)sender;





@end
