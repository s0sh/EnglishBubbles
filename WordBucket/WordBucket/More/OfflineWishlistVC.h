//
//  OfflineWishlistVC.h
//  WordBucket
//
//  Created by Amit Garg on 1/23/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineWishlistVC : GAITrackedViewController

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wordListSaveLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *networkLabel;
@property(nonatomic,assign) BOOL isNetwork;
@property(nonatomic,strong) IBOutlet UITableView *tblWishList;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *offlineWLLbl;



@property(nonatomic,strong) IBOutlet UIButton *btnAddWord;
@property(nonatomic,strong) NSString *strSearchWord;
@property(nonatomic,strong) NSMutableArray *arrWishlist;
-(IBAction)addToWishlist:(id)sender;
- (IBAction)backButtonClicked:(id)sender;


@end
