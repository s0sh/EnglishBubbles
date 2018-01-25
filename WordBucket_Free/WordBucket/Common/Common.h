//
//  Common.h
//  WeddingVenue
//
//  Created by Mehak Bhutani on 11/19/12.
//  Copyright (c) 2012 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#import "WordList.h"

@protocol ImageSaveDelegate

-(void) saveImage;

@end
@protocol ActionSheetDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@protocol PickerDelegate
- (void)closePicker:(NSInteger)tag;
- (void)cancelPicker:(NSInteger)tag;
- (void)nextField:(NSInteger)tag;
- (void)previousField:(NSInteger)tag;
@end
@interface Common : NSObject<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,AVAudioPlayerDelegate>{
    id<ActionSheetDelegate> delegate;
    id<ImageSaveDelegate> imgDelegate;
    id <PickerDelegate> pickerDelegate;
    UISegmentedControl *control;
    NSInteger tagValue;
    UIActivityIndicatorView *activityView;
    AVAudioPlayer *audioPlayer ;
}

@property (strong) WordList * doc;
@property(nonatomic,retain)UISegmentedControl *control ;
@property(nonatomic,strong)  id<ActionSheetDelegate> delegate;
@property(nonatomic,strong)  id<PickerDelegate> pickerDelegate;
@property(nonatomic,strong)  id<ImageSaveDelegate> imgDelegate;
+(Common *) sharedInstance;
- (void)setUpiCloud;
- (void)synconCloud;
-(NSString *) getDatabasePath;
-(NSString *) checkNull:(NSString *) stringToCheck;
- (void)sendEasyTweet:(id)sender text:(NSString *)text withUrl:(NSURL*)urlStr;
-(void)showMailPicker:(id)sender subject:(NSString *)subject emailBody:(NSString *)body;
-(void) popUpActionSheet:(id)sender buttonTitle:(NSArray *)arrButtonTitle desctructiveButtonIndex:(NSInteger)index;
- (UIToolbar *) returnToolbar:(NSInteger) tag frame:(CGRect)frame  ;
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
-(void)stopActivityIndicator:(UIViewController*)controller;
-(void)showActivityIndicator:(UIViewController*)controller;
-(NSInteger) getWordCount:(NSString *)bucketColor;
- (void)postStatusUpdateClick:(UIViewController *)viewController message:(NSString *) message withUrl:(NSURL *)urlStr;
-(NSMutableArray *) swapArrayValues:(NSMutableArray *)array;

-(NSString *) getBucketColor:(NSString *)strColor;
-(NSInteger)getAllWordExceptGreen;
-(NSString *) dateStringForDate:(NSDate *)date;
-(NSDate *) dateFormDateString:(NSString *)str format:(NSString *)format;
-(NSString *) stringDateFromString:(NSString *)stringDate;
- (void)sendSMS:(id)sender message:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;
-(NSInteger) getBucketTestWords:(NSString *)bucketColor action:(NSString *)action;
-(NSInteger) getDateDifference:(NSDate *)startDate endDate:(NSDate *)endDate;
-(void) facebookGraphAPI;
-(UIImage *) getImageWithName:(NSString *)imageName;
-(BOOL) checkInternetConnection;
-(void)savePictureToLibrary:(UIImage *)image;
-(UIImageView *) rotateImage :(UIImageView *) imageView angle:(CGFloat) angle;
-(NSString *) URLEncodeString:(NSString *) str;
-(void) playSound:(id)sender fileName:(NSString *)fileName;

// Class method starte here

+ (NSInteger)dayStringForDate:(NSDate *)date;
+ (NSString*)getStringValueSeperatedByCommaWithArray:(NSMutableArray*)productArray;
+ (NSString*)getCombineStringFromArray:(NSMutableArray*)productArray withKey:(NSString*)key;
+ (void)hideTabBar:(UITabBarController *) tabbarcontroller;
+ (void)showTabBar:(UITabBarController *) tabbarcontroller;
+ (UILabel*)createNewLabelWithTag:(NSInteger)aTag WithFrame:(CGRect)lblframe text:(NSString*)aText noOfLines:(NSInteger)noOfLine color:(UIColor*)color withFont:(UIFont*)font;
+ (NSString*)getTargetLanguage;
+ (NSString*)audioLanguagesWithCode:(NSString*)languageCode;
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image;

+ (void) showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate
      cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+ (void)playCorrectSound;
+ (void)playIncorrectSound;
+ (NSInteger)differencefromtodayDay:(NSDate*)startDate;
+(NSDate *)dateFromString:(NSString*)aStr;
+ (UIFont*)AdjustLabelFont:(UILabel*)label;
@end
