//
//  WordListVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "WordListVC.h"
#import "BucketFullViewC.h"
//#import "FacebookViewC.h"

@interface WordListVC ()

@end

@implementation WordListVC
@synthesize bucketColor,arrWord,arrMeaning,tblSearch,btnRed,btnWhite,btnGreen,btnOrange;

-(void) getWords
{
    
    arrWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = '%@' AND action !='' ORDER BY LOWER(targetWord) ASC",self.bucketColor] withField:@"DISTINCT targetWord"];
    //arrWord = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = '%@' ORDER BY nativeWord ASC",bucketColor] withField:@"DISTINCT nativeWord"];
    arrSection = [[NSMutableArray alloc] init];
    
    
    for(int m =0;m<[arrWord count];m++)
    {        //---get the first char of each Word---
        //unichar alphabet = [[arrWord objectAtIndex:m] characterAtIndex:0];
        unichar alphabet =  toupper([[arrWord objectAtIndex:m] characterAtIndex:0]);
        
        //NSString *uniChar = [NSString stringWithFormat:@"%c", alphabet];
        NSString *uniChar = [[[arrWord objectAtIndex:m] substringToIndex:1] uppercaseString];
        
        //---add each letter to the index array---
        //if (![arrSection containsObject:[uniChar uppercaseString]])
        if (![arrSection containsObject:uniChar])
        {
            [arrSection addObject:uniChar];
        }
    }
    
    for (int j=0;j<[arrSection count];  j++) {
        NSMutableDictionary *arrDict = [NSMutableDictionary dictionary];
        NSString *alphabet = [arrSection objectAtIndex:j];
        
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
        NSArray *Words = [arrWord filteredArrayUsingPredicate:predicate];
        NSMutableArray *wordsArray = [NSMutableArray array];
        for(int k=0;k<[Words count];k++)
        {
            //NSMutableArray * arrMeaning1 = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE nativeWord = '%@' ORDER BY action DESC",[Words objectAtIndex:k]] withField:@"DISTINCT targetWord, action, bucketColor"];
            NSMutableArray * arrMeaning1 = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE targetWord = '%@' ORDER BY action DESC",[Words objectAtIndex:k]] withField:@"DISTINCT nativeWord, action, bucketColor,id,sense,POS"];
            
            
            NSMutableArray *array = [NSMutableArray array];
            NSNumber *colorid = 0;
            for (int i=0; i<[arrMeaning1 count]; i++) {
                NSArray *arr = [[arrMeaning1 objectAtIndex:i] componentsSeparatedByString:@"/|"];
                if([[arr lastObject] isEqualToString:@"White"])
                    colorid = [NSNumber numberWithInt:1];
                else if([[arr lastObject] isEqualToString:@"Red"])
                    colorid = [NSNumber numberWithInt:2];
                else if([[arr lastObject] isEqualToString:@"Orange"])
                    colorid = [NSNumber numberWithInt:3];
                else
                    colorid = [NSNumber numberWithInt:4];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[arrMeaning1 objectAtIndex:i],@"meaning",colorid,@"colorid", nil];
                [array addObject:dict];
            }
            
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"colorid"  ascending:YES];
            [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
            
            arrMeaning = [array copy];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[Words objectAtIndex:k] forKey:@"Word"];
            [dict setValue:arrMeaning forKey:@"Meaning"];
            [dict setObject:@"0" forKey:kisSelected];
            [wordsArray addObject:dict];
            
        }
        
        [arrDict setValue:wordsArray forKey:[NSString stringWithFormat:@"%d",j]]; 
        [arrForTable addObject:arrDict];
    }
    
   // NSLog(@"Main araay is %@",arrForTable);
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"Word" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sorter];
    [(NSMutableArray*)arrForTable sortUsingDescriptors:sortDescriptors];
    [self.tblSearch reloadData];
}
    

- (void)sethighLightSelectedButton
{
    if ([self.bucketColor isEqualToString:@"White"]) {
        [self.btnWhite setSelected:YES];
        _selectedRowImage = @"headerwhitesel";
    } else if ([self.bucketColor isEqualToString:@"Red"]) {
        [self.btnRed setSelected:YES];
        _selectedRowImage = @"headerRed";
    } else if ([self.bucketColor isEqualToString:@"Green"]) {
        [self.btnGreen setSelected:YES];
        _selectedRowImage = @"headergreen";
    } else if ([self.bucketColor isEqualToString:@"Orange"]) {
        [self.btnOrange setSelected:YES];
        _selectedRowImage = @"headerorange";
    } 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isAlreadyInserted = YES;
    arrForTable = [[NSMutableArray alloc] init];
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
//    self.navigationItem.title = [NSString stringWithFormat:@"%@ Bucket",bucketColor] ;
    [self.navigationController.navigationBar setHidden:NO];
    [self getWords];
    [self sethighLightSelectedButton];
    
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Word List Screen";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)reloadTable
{
    [arrForTable removeAllObjects];arrForTable = nil;
    arrForTable = [[NSMutableArray alloc] init];
    [arrSection removeAllObjects];arrSection =nil;
    arrSection = [[NSMutableArray alloc] init];
    [arrWord removeAllObjects];arrWord = nil;
    arrWord = [[NSMutableArray alloc] init];
    [self getWords];
    [tblSearch reloadData];
}

- (void)setAllButtonDeSelected
{
    [self.btnWhite setSelected:NO];
    [self.btnRed setSelected:NO];
    [self.btnOrange setSelected:NO];
    [self.btnGreen setSelected:NO];
    
}

-(IBAction)bucketClick:(id)sender
{    
    NSString *title = nil;
    NSString *message = nil;
    
    switch ([sender tag]) {
        case 1:{
            if ([[Common sharedInstance] getWordCount:@"White"]>0) {
                self.bucketColor = @"White";
                _selectedRowImage = @"headerwhitesel";
            } else {
                title = @"Oops!";
                message = NSLocalizedString(@"You have no words in your White Bucket. Search and save more new words!", nil);
                }
            
            }
            break;
        case 2:{
            if ([[Common sharedInstance] getWordCount:@"Red"]>0) {
                self.bucketColor = @"Red";
                _selectedRowImage = @"headerRed";
            } else {
                title = @"Good work!";
                message = NSLocalizedString(@"Good work! You have no words in your Red Bucket. Only words that you get wrong in the other colours go here.", nil);
            }
            
        }
            break;
        case 3:{
            if ([[Common sharedInstance] getWordCount:@"Orange"]>0) {
                self.bucketColor = @"Orange";
                _selectedRowImage = @"headerorange";
            } else {
                title = @"Sorry!";
                message = [NSString stringWithFormat:NSLocalizedString(@"You have no words in your Orange Bucket. To add words to Orange you must do the White Bucket tests.", nil)];
            }
            
        }
            
            break;
        case 4:{
            if ([[Common sharedInstance] getWordCount:@"Green"]>0) {
                self.bucketColor = @"Green";
                _selectedRowImage = @"headergreen";
            } else {
                title = @"Sorry!";
                message = [NSString stringWithFormat:NSLocalizedString(@"You have no words in your Green Bucket. To add words to Green you must do the Orange Bucket tests.", nil)];
            }
        }
            
            break;
            
        default:
            break;
    }
    
    if (title) {
        [Common showAlertView:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
    } else {
        
        [self setAllButtonDeSelected];
        [sender setSelected:YES];
        [self reloadTable];
    }
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma UITableview datasource methods
//table data source methods

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
   // if (section>0) return YES;
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [arrSection count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *wordsArray = [[arrForTable objectAtIndex:section] valueForKey:[NSString stringWithFormat:@"%d",section]];
    NSLog(@"Count is >> %d",wordsArray.count);
    return [wordsArray count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSMutableArray *wordsArray = [[arrForTable objectAtIndex:indexPath.section] valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    if ([[wordsArray objectAtIndex:indexPath.row] objectForKey:@"Word"]) {
        
        return 46;
    } else {
        return 119;
    }
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:GetImage(@"greyDivider")]];
    
    UILabel *lblHeading = [Common createNewLabelWithTag:section WithFrame:CGRectMake(10, 0, 50, 22) text:[[arrSection objectAtIndex:section] uppercaseString] noOfLines:1 color:[UIColor whiteColor] withFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [headerView addSubview:lblHeading];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    
    UITableViewCell *cell = nil;
    
    NSMutableArray *wordsArray = [[arrForTable objectAtIndex:indexPath.section] valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    NSMutableDictionary *dict = [wordsArray  objectAtIndex: indexPath.row];
    if ([dict objectForKey:@"Word"]) {
        
       // NSString *CellIdentifier = @"Cell";
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    } else {
        //static NSString *CellIdentifier = @"Cell";
        //cell = [tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
           
        }
    }
    
    // Display word on row
    
        if ([dict valueForKey:@"Word"]) {
        
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 290, 44)];
            if([[dict objectForKey:kisSelected] isEqualToString:@"0"])
                [bgImageView setImage:GetImage(@"headerWhite")];
            else
                [bgImageView setImage:GetImage(_selectedRowImage)];
            
            [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
            [bgImageView setTag:20];
            [cell.contentView addSubview:bgImageView];
            //NSLog(@"lower string is %@",[[dict valueForKey:@"Word"] lowercaseString]);
            //NSString *wordString = [[dict valueForKey:@"Word"] lowercaseString];
            UILabel *lblWord = [Common createNewLabelWithTag:30 WithFrame:CGRectMake(25, 11, 180, 21) text:[dict valueForKey:@"Word"] noOfLines:1 color:[UIColor blackColor] withFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [cell.contentView addSubview:lblWord];
            
            
            
        
        } else {
            
            NSMutableDictionary *arrMean = [dict valueForKey:@"Meaning"];
            NSArray *arrSplit = [[arrMean valueForKey:@"meaning"] componentsSeparatedByString:@"/|"];
            UILabel *lblMeaning = (UILabel*)[cell.contentView viewWithTag:102];
            [lblMeaning setText:[arrSplit objectAtIndex:0]];
            
            UILabel *posLabel = (UILabel*)[cell.contentView viewWithTag:104];
            [posLabel setText:[arrSplit objectAtIndex:5]];
            UILabel *senseLabel = (UILabel*)[cell.contentView viewWithTag:105];
            [senseLabel setText:[arrSplit objectAtIndex:4]];
            
            UIButton *shareButton = (UIButton*)[cell.contentView viewWithTag:100];
            [shareButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
            [shareButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
            [shareButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
            [shareButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 2)];
            [shareButton addTarget:self action:@selector(shareButtonClicked:event:) forControlEvents:UIControlEventTouchUpInside];
            //[cell.contentView addSubview:shareButton];
        
            //UIButton *btnBucket = [UIButton buttonWithType:UIButtonTypeCustom];
            //btnBucket.frame = CGRectMake(257, 13, 36, 36);
            UIButton *btnBucket = (UIButton*)[cell.contentView viewWithTag:103];
            [btnBucket addTarget:self action:@selector(addAndRemoveButtonClicked:event:) forControlEvents:UIControlEventTouchUpInside];
            if([[arrSplit objectAtIndex:1] isEqualToString:@""])
            {
                [btnBucket setImage:GetImage(@"addIcon") forState:UIControlStateNormal];

            } else {
                    
                    if([[arrSplit objectAtIndex:2] isEqualToString:@"White"] || [[arrSplit objectAtIndex:2] isEqualToString:@"Saved"])
                        [btnBucket setImage:GetImage(@"bucketWhiteDelete") forState:UIControlStateNormal];
                    else if([[arrSplit objectAtIndex:2] isEqualToString:@"Orange"])
                        [btnBucket setImage:GetImage(@"bucketOrangeDelete") forState:UIControlStateNormal];
                    else if([[arrSplit objectAtIndex:2] isEqualToString:@"Red"])
                        [btnBucket setImage:GetImage(@"bucketRedDelete") forState:UIControlStateNormal];
                    else
                        [btnBucket setImage:GetImage(@"bucketGreenDelete") forState:UIControlStateNormal];
                    
                }
            //[cell.contentView addSubview:btnBucket];
        }
    
   
    return cell;
}


-(void)miniMizeThisRows:(NSArray*)ar section:(NSInteger)section row:(NSInteger)row{
	
	for(NSMutableDictionary *strMean in ar ) {
        NSMutableArray *arrWords = [[arrForTable objectAtIndex:section] valueForKey:[NSString stringWithFormat:@"%d",section]];
        NSInteger indexToRemove=[[arrWords valueForKey:@"Meaning"] indexOfObjectIdenticalTo:strMean];
		
		if([[arrWords valueForKey:@"Meaning"] indexOfObjectIdenticalTo:strMean]!=NSNotFound) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:strMean forKey:@"Meaning"];
			[arrWords removeObject:dictionary];
			[tblSearch deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:section]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationTop];
		}
	}
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    NSMutableArray *wordsArray = [[arrForTable objectAtIndex:indexPath.section] valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    NSMutableDictionary *dict = [wordsArray objectAtIndex:indexPath.row];
    
    if([dict valueForKey:@"Word"])
    {
        NSMutableArray *arrMean = [dict valueForKey:@"Meaning"];
        isAlreadyInserted=NO;
		
		for(NSMutableDictionary *strMeaning in arrMean ){
            NSMutableArray *arrWords = [[arrForTable objectAtIndex:indexPath.section] valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
			NSInteger index=[[arrWords valueForKey:@"Meaning"] indexOfObjectIdenticalTo:strMeaning];
			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
			if(isAlreadyInserted) break;
		}
		
		if(isAlreadyInserted) {
            
			[self miniMizeThisRows:arrMean section:indexPath.section row:indexPath.row];
            UIImageView *bgImageView = (UIImageView*)[cell.contentView viewWithTag:20];
            [bgImageView setImage:GetImage(@"headerWhite")];
            [dict setObject:@"0" forKey:kisSelected];
            
		} else {
            
			NSUInteger count=indexPath.row+1;
			NSMutableArray *arCells=[NSMutableArray array];
			for(NSMutableDictionary *strMean in arrMean ) {
				[arCells addObject:[NSIndexPath indexPathForRow:count inSection:indexPath.section]];
                NSMutableArray *arrWords = [[arrForTable objectAtIndex:indexPath.section] valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:strMean forKey:@"Meaning"];
                [arrWords insertObject:dict atIndex:count++];
			}
			[tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
            UIImageView *bgImageView = (UIImageView*)[cell.contentView viewWithTag:20];
            [bgImageView setImage:GetImage(_selectedRowImage)];
            [dict setObject:@"1" forKey:kisSelected];
            
		}
        
    }
    else
    {
        
        /*
        UITableViewCell *cell = [self.tblSearch cellForRowAtIndexPath:indexPath];
        UILabel *lblMeaning = (UILabel*)[cell.contentView viewWithTag:30];
        [UserDefaluts setObject:lblMeaning.text forKey:@"meaning"];
        NSArray *arrSplit = [[[dict valueForKey:@"Meaning"] objectForKey:@"meaning"] componentsSeparatedByString:@"/|"];
        isRemoved = NO;
        _selectedWord = [arrSplit objectAtIndex:0];
        _idString = [arrSplit objectAtIndex:3];
        _selectedTargetWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT targetWord FROM tbl_Dictionary where id = '%@'",_idString]];
        if([[arrSplit objectAtIndex:1] isEqualToString:@"Removed"] || [[arrSplit objectAtIndex:1] isEqualToString:@""])
            isRemoved = YES;
        if(isRemoved)
        {
            isCurrentColor = YES;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Email",@"Add",@"Cancel", nil];
            [actionSheet setDestructiveButtonIndex:-1];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else if(![[arrSplit objectAtIndex:2] isEqualToString:@"White"])
        {
            isCurrentColor = NO;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Email",@"Cancel", nil];
            [actionSheet setDestructiveButtonIndex:3];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else
        {
            isCurrentColor = YES;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Email",@"Remove",@"Cancel", nil];
            [actionSheet setDestructiveButtonIndex:3];
            //[actionSheet showInView:self.presentedViewController.tabBarController.view];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
         */
        [Common sharedInstance].delegate = self;
       
    }
    
}

- (void)postOnFacebook
{
    NSMutableString *message =[NSString stringWithFormat:NSLocalizedString(@"Do you know this %@ word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.", nil),_selectedTargetWord];
    [[Common sharedInstance] postStatusUpdateClick:self message:message withUrl:[NSURL URLWithString:@"http://www.wordbucket.com"]];
}

#pragma ActionSheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if (actionSheet.tag ==10) {
        
        switch (buttonIndex) {
            case 0:
            {
                // Share on facebook
                [self performSelector:@selector(postOnFacebook) withObject:nil afterDelay:0.5];
                //NSMutableString *message =[NSString stringWithFormat:NSLocalizedString(@"Do you know this %@ word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.", nil),[Common getTargetLanguage],_selectedTargetWord];
                //[[Common sharedInstance] postStatusUpdateClick:self message:message withUrl:[NSURL URLWithString:@"http://www.wordbucket.com"]];
                
            }
                break;
            case 1:
            {
                // Share on twitter
                NSString *message =[NSString stringWithFormat:NSLocalizedString(@"Just found the word \"%@\" in @Wordbucket. Great app to find and learn new words.", nil),_selectedTargetWord];
                [[Common sharedInstance] sendEasyTweet:self text:message withUrl:[NSURL URLWithString:@"http://wordbucket.com"]];
            }
            
                break;
            case 2:
            {
                // Email
                
                /*
                NSString *firstpartStr = [NSString stringWithFormat:NSLocalizedString(@"Do you know this %@ word? \"%@\" I just found it in", nil),[Common getTargetLanguage],_selectedTargetWord];
                NSString *secondpartStr = [NSString stringWithFormat:NSLocalizedString(@"Great app to find and learn new words & FREE to download for iOS and Android.", nil)];
                NSMutableString *message =[NSMutableString stringWithFormat:@"<html><body>%@ <a href=\"http://www.wordbucket.com\">Word Bucket</a>. %@</body></html>",firstpartStr,secondpartStr];*/
                
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Email Do you know this %@ word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.", nil),_selectedTargetWord];
                [[Common sharedInstance] showMailPicker:self subject:NSLocalizedString(@"Word Bucket - find and learn new words", nil) emailBody:message];
            } break;
                
            default:
                break;
        }
        
        
    } else if (actionSheet.tag == 20) {
        
        if (buttonIndex == 0) {
            
            // Add
            NSInteger savedWord = [[UserDefaluts objectForKey:kTotalSavedWord] intValue];
            [UserDefaluts setInteger:(savedWord+1) forKey:kTotalSavedWord];
            [UserDefaluts synchronize];
            isRemoved = NO;
            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = 'White' ,action = 'Saved' WHERE nativeWord = \"%@\" and id = '%@'",_selectedWord,_idString]];
            
            //show alert after adding new word to bucket
            //[NSString stringWithFormat:@"%@ added to Word Bucket",_selectedWord]
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:NSLocalizedString(@"%@ added to your Word Bucket", nil),_selectedWord] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alertView show];
            [self reloadTable];
        }
        
    } else if (actionSheet.tag == 30) {
        
        if (buttonIndex == 0) {
            
            
            // Delete
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:NSLocalizedString(@"Are you sure you want to delete '%@'?", nil),_selectedTargetWord] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Yes", nil),NSLocalizedString(@"No", nil), nil];
            [alertView show];
        }
        
    }  
    
    
    /*
    if(buttonIndex == 0)
    {
        NSMutableString *message =[NSString stringWithFormat: @"Do you know this word? \"%@\" I just found it in Word Bucket. FREE to download for iOS and Android.",[_selectedTargetWord capitalizedString]];
        
        [[Common sharedInstance] postStatusUpdateClick:self message:message withUrl:[NSURL URLWithString:@"http://www.wordbucket.com"]];
    }
    else if(buttonIndex == 1)
    {
        [[Common sharedInstance] sendEasyTweet:self text:[NSString stringWithFormat:@"Just found the word   \"%@\" in Wordbucket. Great app to find and learn new words.",[_selectedTargetWord capitalizedString]] withUrl:[NSURL URLWithString:@"http://www.wordbucket.com"]];
    }
    else if(buttonIndex == 3)
    {
        if(isRemoved && isCurrentColor)
        {
            // Add
            isRemoved = NO;
            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET bucketColor = '%@' ,action = 'Saved' WHERE nativeWord = '%@' and id = '%@'",bucketColor,_selectedWord,_idString]];
            
            //show alert after adding new word to bucket
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ added to Word Bucket",_selectedWord] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            [arrForTable removeAllObjects];
            arrForTable = nil;
            arrForTable = [[NSMutableArray alloc] init];
            [arrSection removeAllObjects];
            arrSection =nil;
            arrSection = [[NSMutableArray alloc] init];
            [arrWord removeAllObjects];
            arrWord = nil;
            arrWord = [[NSMutableArray alloc] init];
            [self getWords];
            //[self.tblSearch reloadData];
        }
        else if(!isCurrentColor){
            
        }
        else
        {
            
            // Delete
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Are you sure to delete %@?",_selectedWord] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
            [alertView show];
            //[self.tblSearch reloadData];
        }
        
    }
    else if(buttonIndex == 2)
    {
        NSMutableString *message =[NSMutableString stringWithFormat:@"<html><body>Do you know this word? \"%@\" I just found it in <a href=\"http://www.wordbucket.com\">Word Bucket</a>. Great app to find and learn new words & FREE to download for iOS and Android.</body></html>",_selectedTargetWord];
        [[Common sharedInstance] showMailPicker:self subject:@"" emailBody:message];
    }
    */
}

#pragma UIAlertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSInteger targetCount = [[DBHelper sharedDbInstance] getRowCountWithQuery:[NSString stringWithFormat:@"SELECT count(*) FROM tbl_Dictionary where targetWord in (select targetWord from tbl_Dictionary where id = '%@')",_idString]];
        
        if (targetCount == 1) {
            [[DBHelper sharedDbInstance] deleteRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary WHERE id = '%@'",_idString]];
            
        } else if (targetCount > 1)
            [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:[NSString stringWithFormat:@"tbl_Dictionary SET action = '' WHERE nativeWord = '%@' and id = '%@'",_selectedWord,_idString]];
    }
   
    [self reloadTable];
    
    //[self.tblSearch reloadData];
}


- (void)shareButtonClicked:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tblSearch];
    NSIndexPath *indexPath = [self.tblSearch indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"index path in button tapped is %d %d",indexPath.section,indexPath.row);
    
    NSMutableArray *wordsArray = [[arrForTable objectAtIndex:indexPath.section] valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    NSMutableDictionary *dict = [wordsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tblSearch cellForRowAtIndexPath:indexPath];
    UILabel *lblMeaning = (UILabel*)[cell.contentView viewWithTag:30];
    [UserDefaluts setObject:lblMeaning.text forKey:@"meaning"];
    NSArray *arrSplit = [[[dict valueForKey:@"Meaning"] objectForKey:@"meaning"] componentsSeparatedByString:@"/|"];
    isRemoved = NO;
    _selectedWord = [arrSplit objectAtIndex:0];
    _idString = [arrSplit objectAtIndex:3];
    _selectedTargetWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT targetWord FROM tbl_Dictionary where id = '%@'",_idString]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share on Facebook", nil),NSLocalizedString(@"Share on Twitter", nil),NSLocalizedString(@"Email", nil),NSLocalizedString(@"Cancel", nil), nil];
    [actionSheet setTag:10];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    
}
- (void)addAndRemoveButtonClicked:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tblSearch];
    NSIndexPath *indexPath = [self.tblSearch indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"index path in button tapped is %d %d",indexPath.section,indexPath.row);
    
    NSMutableArray *wordsArray = [[arrForTable objectAtIndex:indexPath.section] valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    NSMutableDictionary *dict = [wordsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tblSearch cellForRowAtIndexPath:indexPath];
    UILabel *lblMeaning = (UILabel*)[cell.contentView viewWithTag:30];
    [UserDefaluts setObject:lblMeaning.text forKey:@"meaning"];
    NSArray *arrSplit = [[[dict valueForKey:@"Meaning"] objectForKey:@"meaning"] componentsSeparatedByString:@"/|"];
    isRemoved = NO;
    _selectedWord = [arrSplit objectAtIndex:0];
    _idString = [arrSplit objectAtIndex:3];
    _selectedTargetWord = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"SELECT targetWord FROM tbl_Dictionary where id = '%@'",_idString]];
    
    if([[arrSplit objectAtIndex:1] isEqualToString:@"Removed"] || [[arrSplit objectAtIndex:1] isEqualToString:@""])
        isRemoved = YES;
    
    if(isRemoved)
    {
        //NSInteger savedWord = [[UserDefaluts objectForKey:kTotalSavedWord] intValue];
        isCurrentColor = YES;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Add", nil),NSLocalizedString(@"Cancel", nil), nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet setTag:20];
            
        
    }
    
    else
    {
        
        isCurrentColor = YES;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Remove", nil),NSLocalizedString(@"Cancel", nil), nil];
        [actionSheet setDestructiveButtonIndex:0];
        [actionSheet setTag:30];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    
}



/*
- (void)soundButtonClicked:(UIButton*)soundButton
{
    NSString *wordString = [soundButton titleForState:UIControlStateNormal];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSString *speechString = [NSString stringWithFormat:@"http://api.ispeech.org/api/rest?apikey=7f8881533336716f3a0bf6b17558d4b9&action=convert&voice=%@&format=mp3 &frequency=44100&bitrate=128&speed=1&startpadding=1&endpadding=1&pitch=110&filename=audiofile&text=%@",[Common audioLanguagesWithCode:[UserDefaluts objectForKey:kTargetLangCode]],wordString];
    NSString *properlyEscapedURL = [speechString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue // created at class init
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               // do something with data or handle error
                               NSLog(@"resopne and data is ");
                               if(!error){
                                   NSError *error1 = nil;
                                   //_audioPlayer=nil;
                                   _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error1];
                                   [_audioPlayer prepareToPlay];
                                   _audioPlayer.delegate = self;
                                   if (_audioPlayer == nil)
                                       NSLog(@"error%@",[error1 localizedDescription]);
                                   else
                                       [_audioPlayer play];
                               } else {
                                   NSLog(@"error is %@",[error localizedDescription]);
                               }
                           }];

}
*/


- (IBAction)homeButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    
    
    _audioPlayer=nil;
    [self setArrMeaning:nil];
    [self setArrWord:nil];
    [self setSelectedWord:nil];
    [self setSelectedTargetWord:nil];
    [super viewDidUnload];
}
@end
