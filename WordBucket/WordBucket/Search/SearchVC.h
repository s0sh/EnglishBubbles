//
//  SearchVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Common.h"
#import "Server.h"
#import <AVFoundation/AVFoundation.h>

@interface SearchVC : GAITrackedViewController<UITextFieldDelegate,MFMailComposeViewControllerDelegate,ActionSheetDelegate,WebserviceDelegate,AVAudioPlayerDelegate,UIActionSheetDelegate>{
    DBHelper *dbHelper;
    NSMutableArray *tableIndex;
    dispatch_queue_t backgroundQueue;
    BOOL wordExists;
    AVAudioPlayer *audioPlayer;
    Server *objServer;
    NSURL *url;
    NSOperationQueue *queue;
}


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *searchWordLbl;
@property (nonatomic, strong) NSString *strSearchWord;
@property (nonatomic, strong) NSString *shareWord;
@property (nonatomic, strong) IBOutlet UITableView *tblMeaningList;
@property (nonatomic, strong) NSMutableArray *arrMeaningList;
@property (nonatomic, strong) IBOutlet UIButton *addTranslation;

-(void) addToBucket:(id)sender  event:(id)event;
-(void) shareWord:(id)sender event:(id)event;
- (IBAction)homeButtonClicked:(id)sender;
- (void)addTranslation:(id)sender;
@end
