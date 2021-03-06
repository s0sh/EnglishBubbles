//
//  MoreVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 12/28/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "MoreVC.h"
#import "HistoryVC.h"
#import "SettingsViewC.h"
#import "OfflineWishlistVC.h"
#import "CreditViewC.h"
#import "LearnEngTGameViewC.h"
#import "InfoViewC.h"
#import "UpdateViewC.h"

@interface MoreVC ()

@end

@implementation MoreVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"More", @"More");
        //self.tabBarItem.image = [UIImage imageNamed:@"first"];
        // Custom initialization
    }
    return self;
}


- (void)setLocalizedString
{
    NSString *historyStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"History", nil)];
    NSString *rateWBStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Rate Word Bucket", nil)];
    NSString *settingStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Settings", nil)];
    NSString *WBCreditStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Word Bucket credits", nil)];
    NSString *offlineWLStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Offline Wishlist", nil)];
    NSString *updateWBStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Upgrade Word Bucket", nil)];
    NSString *howsitWorkStr = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Word Bucket: How it works", nil)];
    [_btnHistory setTitle:historyStr forState:UIControlStateNormal];
    [_btnRateWordBucket setTitle:rateWBStr forState:UIControlStateNormal];
    [_btnSetting setTitle:settingStr forState:UIControlStateNormal];
    [_btnWBCredit setTitle:WBCreditStr forState:UIControlStateNormal];
    [_btnOfflineWishList setTitle:offlineWLStr forState:UIControlStateNormal];
    [_btnUpdateWB setTitle:updateWBStr forState:UIControlStateNormal];
    [_btnHowsItWork setTitle:howsitWorkStr forState:UIControlStateNormal];
    [_btnHistory.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnRateWordBucket.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnWBCredit.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnOfflineWishList.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnSetting.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnUpdateWB.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btnHowsItWork.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_moreLabel setText:NSLocalizedString(@"More", nil)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLocalizedString];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"More Screen";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    
    for (int k = 100; k<=107; k++) {
        UIButton *moreButton = (UIButton*)[self.view viewWithTag:k];
        [moreButton setSelected:NO];
    }
    
    
    [_scrollView setContentSize:CGSizeMake(320, 274)];
    [_containerImgView setFrame:CGRectMake(13, SharedAppDelegate.isPhone5 ? 60 : 0, 295, 274)];
    
    
    if ([[[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tbl_Wishlist"]] intValue] >0) {
        [_whishListButton setHidden:NO];
        
    } else {
        [_whishListButton setHidden:YES];
        [_containerImgView setFrame:CGRectMake(13, SharedAppDelegate.isPhone5 ? 60 : 0, 295, 229)];
        [_scrollView setContentSize:CGSizeMake(320, 229)];
    }
    
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        HistoryVC *history = [[HistoryVC alloc] initWithNibName:@"HistoryVC" bundle:nil];
        [self.navigationController pushViewController:history animated:YES];
    }
    else if(indexPath.section == 1)
    {
        SettingsVC *settings = [[SettingsVC alloc] initWithNibName:@"SettingsVC" bundle:nil];
        [self.navigationController pushViewController:settings animated:YES];
    }
    else if(indexPath.section == 2)
    {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=AppID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
    }
    else if(indexPath.section == 2)
    {
        OfflineWishlistVC *list = [[OfflineWishlistVC alloc] initWithNibName:@"OfflineWishlistVC" bundle:nil];
        [self.navigationController pushViewController:list animated:YES];
    }
}
*/

- (IBAction)homeButtonClicked:(id)sender {
    
    for(UIView *view in self.tabBarController.tabBar.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.tabBarController setSelectedIndex:1];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"learn.png"]];
    [self.tabBarController.tabBar insertSubview:imgView atIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWordListViewNotification object:self userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:kNote]];
}




- (IBAction)moreButtonClicked:(id)sender {
    
    [sender setSelected:YES];
    
    switch ([sender tag]) {
        case 100:
        {
            
            // History
            NSString *nib = SharedAppDelegate.isPhone5 ? @"HistoryVC" : @"HistoryVCiPhone4";
            HistoryVC *history = [[HistoryVC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:history animated:YES];
        }
            break;
        case 101:
        {
            
            // Settings
            NSString *nib = SharedAppDelegate.isPhone5 ? @"SettingsViewC" : @"SettingsViewCiPhone4";
            SettingsViewC *settings = [[SettingsViewC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:settings animated:YES];
        }
            break;
        case 102:
        {
            
            // Rate Word Bucket
            NSString *rateString = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",kWBPaidAppId];
            //NSString *rateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kWBPaidAppId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateString]];
        }
            break;
        case 103:
        {
            // Learn English through game
            NSString *nib = SharedAppDelegate.isPhone5 ? @"LearnEngTGameViewC" : @"LearnEngTGameViewCiPhone4";
            LearnEngTGameViewC *learnEngObj = [[LearnEngTGameViewC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:learnEngObj animated:YES];
        }
            break;
        case 104:
        {
            //Push Credit screen
            NSString *nib = SharedAppDelegate.isPhone5 ? @"CreditViewC" : @"CreditViewCiPhone4";
            CreditViewC *creditobj = [[CreditViewC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:creditobj animated:YES];
        }
            break;
        case 105:
        {
            //Upgrade Word Bucket
            NSString *nib = SharedAppDelegate.isPhone5 ? @"UpdateViewC" : @"UpdateViewCiPhone4";
            UpdateViewC *updateObj = [[UpdateViewC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:updateObj animated:YES];
        }
            break;
        case 106:
        {
            //Hows it works
            NSString *nib = SharedAppDelegate.isPhone5 ? @"InfoViewC" : @"InfoViewCiPhone4";
            InfoViewC *infoVCObj = [[InfoViewC alloc] initWithNibName:nib bundle:nil];
            [self.navigationController pushViewController:infoVCObj animated:YES];
        }
            break;
        case 107:
        {
            //Wish List
            NSString *nib = SharedAppDelegate.isPhone5 ? @"OfflineWishlistVC" : @"OfflineWishlistVCiPhone4";
            OfflineWishlistVC *list = [[OfflineWishlistVC alloc] initWithNibName:nib bundle:nil];
            list.strSearchWord = @"";
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)viewDidUnload {
    [self setContainerImgView:nil];
    [self setScrollView:nil];
    [self setWhishListButton:nil];
    [self setBtnHistory:nil];
    [self setBtnSetting:nil];
    [self setBtnRateWordBucket:nil];
    [self setBtnWBCredit:nil];
    [self setBtnUpdateWB:nil];
    [self setBtnHowsItWork:nil];
    [self setBtnOfflineWishList:nil];
    [self setMoreLabel:nil];
    [super viewDidUnload];
}
@end
