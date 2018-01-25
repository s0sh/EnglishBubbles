//
//  SendAWordVC.h
//  WordBucket
//
//  Created by Mehak Bhutani on 12/28/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface SendAWordVC : GAITrackedViewController{
    DBHelper *dbHelper;
    
}


@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtSearch;
@property(nonatomic,strong) IBOutlet UIButton *btnWhite;
@property(nonatomic,strong) IBOutlet UIButton *btnGreen;
@property(nonatomic,strong) IBOutlet UIButton *btnOrange;
@property(nonatomic,strong) IBOutlet UIButton *btnRed;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblExploreBucket;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblLearning;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblNew;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblLearned;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblMistakes;



-(IBAction)whiteBucket:(id)sender;
-(IBAction)greenBucket:(id)sender;
-(IBAction)orangeBucket:(id)sender;
-(IBAction)redBucket:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)searchClicked:(id)sender;



@end
