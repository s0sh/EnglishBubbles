//
//  OfflineWishlistVC.m
//  WordBucket
//
//  Created by Amit Garg on 1/23/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "OfflineWishlistVC.h"
#import "SearchVC.h"
#import "DBHelper.h"
@interface OfflineWishlistVC ()

@end

@implementation OfflineWishlistVC
@synthesize tblWishList,btnAddWord,strSearchWord,arrWishlist;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) refreshTable
{
    self.arrWishlist=nil;
    self.arrWishlist = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Wishlist" withField:@"word,isNativeSearch"];
    [self.tblWishList reloadData];
}

- (void)setLocalizedString
{
    [_offlineWLLbl setText:NSLocalizedString(@"Your Offline Wishlist", nil)];
    [_networkLabel setText:NSLocalizedString(@"Oops! It seems you have no Internet connection. Don't worry. Just add your words here and you can search and save them to your Bucket later.", nil)];
    [_networkLabel sizeToFit];
    [_wordListSaveLabel setText:NSLocalizedString(@"Words already saved in Wishlist", nil)];
    NSString *btnTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Add %@ to Wishlist", nil)];
    NSString *finalString = [NSString stringWithFormat:btnTitle,self.strSearchWord];
    [self.btnAddWord setTitle:finalString forState:UIControlStateNormal];
    [self.btnAddWord.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self setLocalizedString];
    
    
    [_wordListSaveLabel setBackgroundColor:[UIColor colorWithPatternImage:GetImage(@"creditblue")]];
    
    //arrWishlist = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Wishlist" withField:@"word"];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *dividerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 295, 2)];
    [dividerImgView setContentMode:UIViewContentModeScaleAspectFill];
    [dividerImgView setImage:GetImage(@"bottomcolor")];
    UIImageView *divideFooterImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 295, 2)];
    [divideFooterImgView setContentMode:UIViewContentModeScaleAspectFill];
    [divideFooterImgView setImage:GetImage(@"bottomcolor")];
    //self.tblWishList.tableHeaderView = dividerImgView;
    self.tblWishList.tableFooterView = divideFooterImgView;
    dividerImgView=nil;
    
    
    if (self.strSearchWord.length==0) {
        
        [_networkLabel setHidden:YES];
        [self.btnAddWord setHidden:YES];
        [_wordListSaveLabel setFrame:CGRectMake(15, 63, 290, 44)];
        [self.tblWishList setFrame:CGRectMake(15, 107, 290, SharedAppDelegate.isPhone5 ? 390 : 302)];
    }
    
    _isNetwork = [[Common sharedInstance] checkInternetConnection];
    [self refreshTable];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Offline Wishlist Screen";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(IBAction)addToWishlist:(id)sender
{
    [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Wishlist" withField:@"word,isNativeSearch" fieldValue:[NSString stringWithFormat:@"'%@','%@'",self.strSearchWord,SharedAppDelegate.isNativeSrchLang ? @"1" : @"0"]];
    [self refreshTable];
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma UITableview datasource methods
//table data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrWishlist count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    if(_isNetwork)
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    else
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *splitArray = [[self.arrWishlist  objectAtIndex:indexPath.row] componentsSeparatedByString:@"/|"];
    UILabel *wordLabel = [Common createNewLabelWithTag:0 WithFrame:CGRectMake(20, 9, 200, 25) text:[NSString stringWithFormat:@"%@",[splitArray  objectAtIndex:0]] noOfLines:1 color:LabelColor withFont:[UIFont fontWithName:@"Hevetica-Neue-Light" size:16]];
    [cell.contentView addSubview:wordLabel];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    wordLabel=nil;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([[Common sharedInstance] checkInternetConnection])
    {
        UITableViewCell *cell = [self.tblWishList cellForRowAtIndexPath:indexPath];
        UILabel *lblWord = [cell.contentView.subviews objectAtIndex:0];
        NSArray *splitArray = [[arrWishlist  objectAtIndex:indexPath.row] componentsSeparatedByString:@"/|"];
         [[DBHelper sharedDbInstance] deleteRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Wishlist WHERE word = '%@'",lblWord.text]];
        SearchVC *search = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
        search.strSearchWord = lblWord.text;
        SharedAppDelegate.isNativeSrchLang = [[splitArray objectAtIndex:1] boolValue];
        [self.navigationController pushViewController:search animated:YES];
        [self refreshTable];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [self setArrWishlist:nil];
    [self setTblWishList:nil];
    [self setNetworkLabel:nil];
    [self setWordListSaveLabel:nil];
    [self setOfflineWLLbl:nil];
    [super viewDidUnload];
}
@end
