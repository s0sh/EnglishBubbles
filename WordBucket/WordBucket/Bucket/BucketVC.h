//
//  BucketVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBHelper.h"
#import "CMTabBarController.h"
#import <UIKit/UITextChecker.h>
#import "Common.h"
@interface BucketVC : UIViewController<PickerDelegate, CMTabBarControllerDelegate>{
    DBHelper *dbHelper;
    
}
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property(nonatomic,strong) IBOutlet UIButton *btnWhite;
@property(nonatomic,strong) IBOutlet UIButton *btnGreen;
@property(nonatomic,strong) IBOutlet UIButton *btnOrange;
@property(nonatomic,strong) IBOutlet UIButton *btnRed;

@property(nonatomic,strong) IBOutlet UIButton *btnSearch;
@property(nonatomic,strong) IBOutlet UITextField *txtSearch;

@property(nonatomic,strong) IBOutlet UIButton *btnCommunity;
@property(nonatomic,strong) IBOutlet UIButton *btnLearn;
@property(nonatomic,strong) IBOutlet UIButton *btnMore;

-(IBAction)whiteBucket:(id)sender;
-(IBAction)greenBucket:(id)sender;
-(IBAction)orangeBucket:(id)sender;
-(IBAction)redBucket:(id)sender;

-(IBAction)searchClicked:(id)sender;

-(IBAction)tabBarClicked:(id)sender;
@end
