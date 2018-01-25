//
//  Defines.h
//  WordBucket
//
//  Created by Mehak Bhutani on 1/21/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//


#define kWhite      @"White"
#define kRed        @"Red"
#define kOrange     @"Orange"
#define kGreen      @"Green"

#define kWhiteTest1         @"WhiteTest1"
#define kWhiteTest2         @"WhiteTest2"
#define kOrangeTest1        @"OrangeTest1"
#define kOrangeTest2        @"OrangeTest2"
#define kRedTest            @"RedTest"
#define kGreenTest          @"GreenTest"

#define kUserId             @"userId"
#define kUserEmail          @"userEmail"

// Dictionary table
#define kId                 @"id"
#define kTargetWord         @"targetWord"
#define kNativeWord         @"nativeWord"
#define kNativeLanguage     @"nativeLanguage"
#define kTargetLanguage     @"targetLanguage"
#define kAction             @"action"
#define kUserLevel          @"userLevel"
#define kdateOfTest         @"dateOfTest"
#define ksense              @"sense"
#define kPOS                @"POS"

#define kTestType           @"testType"
//valueForKey:@"nativeLanguageCode"],[UserDefaluts valueForKey:@"targetLanguageCode"]);

#define kNativeLangCode @"nativeLanguageCode"
#define kTargetLangCode @"targetLanguageCode"




#define kWordListViewNotification       @"WordListViewNotification"

#define kRetakeGreenTestNotification    @"RetakeGreenTestNotification"
#define kRetakeOrangeTestNotification   @"RetakeOrangeTestNotification"
#define kRetakeWhiteTestNotification    @"RetakeWhiteTestNotification"
#define kRetakeRedTestNotification      @"RetakeRedTestNotification"
#define kRetakeAllTestNotification      @"RetakeAllTestNotification"

#define kRetakeTestNotification         @"RetakeTestNotification"
#define kPauseWhenAppGoesInBack         @"PauseWhenAppGoesInBackground"

#define kBucketColor                    @"BucketColor"

#define kNote                           @"Note"
#define kisSelected                     @"Selected"
#define kTotalWords                     @"TotalWords"

#define kWhiteTestCount                 @"WhiteTestCount"
#define kOrangeTestCount                @"OrangeTestCount"
#define kGreenTestCount                 @"GreenTestCount"
#define kRedTestCount                   @"RedTestCount"
#define kTotalSearchWord                @"TotalSearchWord"
#define kTotalSavedWord                 @"TotalSavedWord"
#define kCorrectCounter                 @"correctCounter"
#define kisAppActive                    @"AppIsActive"
#define kisSoundOn                      @"isSoundOn"
#define kUserName                       @"UserName"

#define kLaunchCount                    @"LaunchCount"
#define kLanchDate                      @"LanchDate"

#define kFirstLaunchOrangeTest          @"FirstLaunchOrangeTest"
#define kFirstLaunchAllTest             @"FirstLaunchAllTest"

#define kWordOfWeek                     @"wordOfWeek"
#define kLink                           @"link"

#define kWBPaidAppId                    @"578570325"
#define kWBFreeAppId                    @"647575834"


#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define degreesToRadians(x) (M_PI * x / 180.0)
#define kWordPlist          @"WordList.plist"
#define kFILENAME           @"WordBucketWords.dox"
#define kNewWord            @"CategoryConquestWords.dox"



//WBWordList = WordBucketWords
//newWord = CategoryConquestWords

#define kisUpgrade          @"Upgrade"

#ifndef WordBucket_Defines_h
#define WordBucket_Defines_h

#define kSpeechUrl @"http://api.ispeech.org/api/rest?apikey=developerdemokeydeveloperdemokey&action=convert&voice=usenglishfemale&format=mp3 &frequency=44100&bitrate=128&speed=1&startpadding=1&endpadding=1&pitch=110&filename=audiofile"

#define SharedAppDelegate   ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UserDefaluts        [NSUserDefaults standardUserDefaults]
#define LabelColor           [UIColor colorWithRed:36.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.0]

#define GetImage(imageName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]]

#endif
