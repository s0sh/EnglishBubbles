//
//  SplashVC.m
//  WordBucket
//
//  Created by Mehak Bhutani on 11/27/12.
//  Copyright (c) 2012 Mehak Bhutani. All rights reserved.
//

#import "SplashVC.h"
#import "CustomTextField.h"
#import "NSData+Base64.h"
#import "InfoViewC.h"
#import "DBHelper.h"
#import "WordList.h"

//#import "BucketVC.h"
@interface SplashVC ()

@end

@implementation SplashVC
@synthesize tblLanguageList,arrLanguages,arrLabelText,toolbar,arrUserLevel,activePickerField,imageAvatar,arrTargetLanguages,activeField,targetPickerField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    

}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    //dbHelper = [[DBHelper alloc] init];
    tblLanguageList.separatorColor = [UIColor lightGrayColor];
    [UserDefaluts setBool:YES forKey:@"splashDone"];
    

    // Normal condition
    
    //arrLanguages = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Language where id NOT IN(5,9) Order By languageName ASC" withField:@"languageName"];
    //arrLanguages = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Arabic", nil),NSLocalizedString(@"Chinese", nil),NSLocalizedString(@"English", nil),NSLocalizedString(@"French", nil),NSLocalizedString(@"Spanish", nil),nil];
    arrLanguages = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Arabic", nil),NSLocalizedString(@"Chinese", nil),NSLocalizedString(@"English", nil),NSLocalizedString(@"French", nil),NSLocalizedString(@"German", nil),NSLocalizedString(@"Italian", nil),NSLocalizedString(@"Japanese", nil),NSLocalizedString(@"Korean", nil),NSLocalizedString(@"Portuguese", nil),NSLocalizedString(@"Russian", nil),NSLocalizedString(@"Spanish", nil), nil];
    arrTargetLanguages = [[NSMutableArray alloc]
                          initWithObjects:NSLocalizedString(@"English", nil), nil];
    
    // Build for WordReference
    
    //arrLanguages = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Language where id NOT IN(9) Order By languageName ASC" withField:@"languageName"];
    //self.arrTargetLanguages = [[NSMutableArray alloc] initWithArray:arrLanguages];
    //[arrTargetLanguages removeObjectAtIndex:0];
    
    
    
    

    arrLabelText = [NSArray arrayWithObjects:NSLocalizedString(@"Your Word Bucket name", nil) ,NSLocalizedString(@"Your Word Bucket Avatar", nil),NSLocalizedString(@"Your native language", nil) ,NSLocalizedString(@"The language you're learning", nil),NSLocalizedString(@"Your language level", nil),nil];
    arrUserLevel = [NSArray arrayWithObjects:NSLocalizedString(@"Beginner", nil),NSLocalizedString(@"Intermediate", nil),NSLocalizedString(@"Advanced", nil), nil];
    NSString *finishString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"FINISH", nil)];
    [self.btnFinish setTitle:finishString forState:UIControlStateNormal];
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [UserDefaluts setObject:@"ar" forKey:kNativeLangCode];
    [UserDefaluts setObject:@"en" forKey:kTargetLangCode];
    [UserDefaluts setObject:@"Beginner" forKey:kUserLevel];
    [UserDefaluts synchronize];
    NSLog(@"%@ %@ %@",[UserDefaluts objectForKey:kNativeLangCode],[UserDefaluts objectForKey:kTargetLangCode],[UserDefaluts objectForKey:kUserLevel]);
    
    //  profile imageview
    self.imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, SharedAppDelegate.isPhone5 ? 23: 26, 33, 32)];
    
    
    NSString *htmlString = NSLocalizedString(@"By clicking Finish you are indicating that you have read and agreed to the <a href=\"http://wordbucket.com/en/privacy/\">Privacy Policy</a> and <a href=\"http://wordbucket.com/en/terms-of-service/\">Terms of Service</a>.", nil);
    NSString *loadString = [NSString stringWithFormat:@"<html><head><style>body {background:transparent; font-family:Helvetica Neue Medium; color: #3C515C; font-size:14px} p {color:#3C515C;}</style></head><body><p>%@<p></body></html>", htmlString];
    CGSize constraint = CGSizeMake(295, 2000.0f);
    CGSize size = [htmlString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"%@",NSStringFromCGSize(size));
    
    [_termsAndCond loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\" face=\"Bookman Old Style, Book Antiqua, Garamond\" size=\"1\">%@</body></html>", loadString] baseURL: nil];
    [_termsAndCond setFrame:CGRectMake(13, 353, 295, size.height)];
    [_termsAndCond.scrollView setScrollEnabled:NO];
    //[_termsAndCond sizeToFit];
    [self.scrollView setContentSize:CGSizeMake(320, SharedAppDelegate.isPhone5 ? 470 : 570)];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Login Screen";
    [SharedAppDelegate.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"All_Test" action:@"AllTest_Test_Begin" label:@"WordBucket-Paid" value:nil] build]];
}



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //CAPTURE USER LINK-CLICK.
    NSURL *url = [request URL];
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"url is %@",url);
        [[UIApplication sharedApplication] openURL:url];
        return NO;
        
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableview datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{     
    // Return the number of rows in the section.
    return [arrLabelText count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lblUserLevel = [[UILabel alloc] initWithFrame:CGRectMake(13, 6, 250, 25)];
    [lblUserLevel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
    lblUserLevel.backgroundColor = [UIColor clearColor];
//    NSArray *arrLangs = [[arrLanguages objectAtIndex:indexPath.row] componentsSeparatedByString:@"/|"];
    [lblUserLevel setText:[arrLabelText objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:lblUserLevel];
 
    if(indexPath.row == 0)
    {
        txtName = [[CustomTextField alloc] init];
        txtName.verticalPadding = 0;
        txtName.horizontalPadding = 10;
        txtName.delegate = self;
        [txtName setBackground:[UIImage imageNamed:@"textfield@2x.png"]];
        [txtName setPlaceholder:NSLocalizedString(@"Type your Word Bucket name", nil)];
        [txtName setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:13]];
        [cell.contentView addSubview:txtName];
        
        if ([UserDefaluts boolForKey:@"iPhone5"])
            txtName.frame = CGRectMake(13, 30, 260, 30);
        else
            txtName.frame = CGRectMake(13, 33, 260, 24);
        
    }
    else if(indexPath.row == 1)
    {
        UIImageView *imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(13, SharedAppDelegate.isPhone5 ? 15:18, 50, 50)];
        imgAvatar.image = [UIImage imageNamed:@"imageContainer.png"];
        [cell.contentView addSubview:imgAvatar];
        [cell.contentView addSubview:self.imageAvatar];
        
        self.imageAvatar.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.imageAvatar.transform = CGAffineTransformMakeRotation(degreesToRadians(-15));
        imgAvatar.layer.anchorPoint = CGPointMake(0.5, 0.5);
        imgAvatar.transform = CGAffineTransformMakeRotation(degreesToRadians(-15));
        
        lblUserLevel.frame = CGRectMake(85, 15, 250, 25);
        UIButton *btnAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAvatar.frame = CGRectMake(85, 39, 157, 20);
        btnAvatar.tag = indexPath.row;
        [btnAvatar.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10]];
        [btnAvatar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSLog(@"titiel is %@",NSLocalizedString(@"CHOOSE FROM GALLERY", nil));
        [btnAvatar setTitle:NSLocalizedString(@"CHOOSE FROM GALLERY", nil) forState:UIControlStateNormal];
        [btnAvatar setContentEdgeInsets:UIEdgeInsetsMake(0.0, 21.0, 0.0, 2.0)];
        [btnAvatar setBackgroundImage:[UIImage imageNamed:@"galleryBtn@2x.png"] forState:UIControlStateNormal];
        [btnAvatar.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [btnAvatar addTarget:self action:@selector(chooseFromGallery:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnAvatar];
        btnAvatar = nil;
    }
    else
    {
        
        UIButton *txtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(SharedAppDelegate.isPhone5){
            lblUserLevel.frame = CGRectMake(13, 18, 250, 25);
            //pickerInfo.frame = CGRectMake(13, 42, 260, 20);
        }
        else{
            lblUserLevel.frame = CGRectMake(13, 20, 250, 25);
            //pickerInfo.frame = CGRectMake(13, 45, 260, 20);
        }
        
        NWPickerField *pickerInfo = [[NWPickerField alloc] initWithFrame:CGRectMake(13, 43, 260, 20)];
        //CustomTextField *pickerInfo = [[CustomTextField alloc] initWithFrame:CGRectMake(13, 43, 260, 20)];
        if(SharedAppDelegate.isPhone5){
            lblUserLevel.frame = CGRectMake(13, 18, 250, 25);
            pickerInfo.frame = CGRectMake(13, 42, 260, 20);
            [txtButton setFrame:CGRectMake(13, 22, 260, 40)];
            
        } else {
            
            lblUserLevel.frame = CGRectMake(13, 20, 250, 25);
            pickerInfo.frame = CGRectMake(13, 45, 260, 20);
            [txtButton setFrame:CGRectMake(13, 25, 260, 40)];
        }
        
        [pickerInfo setBackground:[UIImage imageNamed:@"chooseLanguage@2x.png"]];
        pickerInfo.delegate = self;
        pickerInfo.tag = [[NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row] intValue];
        [pickerInfo setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
        [pickerInfo setTextColor:[UIColor whiteColor]];
        if(indexPath.row==2)
            [pickerInfo setText:NSLocalizedString(@"Arabic", nil)];
        [cell.contentView addSubview:pickerInfo];
        if(indexPath.row == 3){
            targetPickerField = pickerInfo;
            [pickerInfo setText:NSLocalizedString(@"English", nil)];
        }
        pickerInfo = nil;
        
        [txtButton setTag:indexPath.row];
        [txtButton addTarget:self action:@selector(makeTextFieldFirstResponder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:txtButton];
    }
    
    
    return cell;
}
#pragma UITableview delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)makeTextFieldFirstResponder:(id)sender
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSInteger tag = [[NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row] intValue];
    UITableViewCell *cell = [self.tblLanguageList cellForRowAtIndexPath:indexPath];
    NWPickerField *pickerInfo = (NWPickerField*)[cell.contentView viewWithTag:tag];
    [pickerInfo becomeFirstResponder];
}


#pragma mark - Text field delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    //add toolbar
    activeField = (CustomTextField*)textField;
    if(toolbar)
        [toolbar removeFromSuperview];
    toolbar = [[Common sharedInstance] returnToolbar:textField.tag frame:CGRectMake(0.0,
                                                                                    200,
                                                                                    320,
                                                                                    44)];
//    toolbar.frame = CGRectMake(0.0,156, 320,44);
    toolbar.tag = 0;
    [Common sharedInstance].pickerDelegate = self;
    [self.view addSubview:toolbar];
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark -
#pragma mark NWPickerField
#pragma mark -

-(NSInteger) numberOfComponentsInPickerField:(NWPickerField*)pickerField {
	
	return 1;
}

-(NSInteger) pickerField:(NWPickerField*)pickerField numberOfRowsInComponent:(NSInteger)component{
	switch(pickerField.tag) {
            
		case 2:
			//return [[cars objectAtIndex:component] count];
			return [arrLanguages count];
			break;
        case 3:
			return [arrTargetLanguages count];
			break;
        case 4:
			return [arrUserLevel count];
			break;
		default:
			return 1;
			
    }
	
}

-(NSString *) pickerField:(NWPickerField *)pickerField titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    NSString *strTag = [NSString stringWithFormat:@"%d", pickerField.tag];
    NSString *section = @"0";
    NSString *pickerRow = @"0";
    if([strTag length]>1)
    {
        section = [strTag substringWithRange:NSMakeRange(0, [strTag length]-1)];
        pickerRow = [strTag substringFromIndex:1];
    }
    else
        pickerRow = strTag;
  
	switch(pickerField.tag) {
            
		case 2:
			return [arrLanguages objectAtIndex:row];
            //return NSLocalizedString([arrLanguages objectAtIndex:row], nil);
			break;
		case 3:
            return [arrTargetLanguages objectAtIndex:row];
            //return NSLocalizedString([arrTargetLanguages objectAtIndex:row], nil) ;
			break;
		case 4:
            return [arrUserLevel objectAtIndex:row];
			break;
			
		default:
			return nil;

    }
    return nil;
}


- (void)pickerField:(NWPickerField *)pickerField didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if(pickerField.tag == 0)
    {
        switch (row) {
            case 0:
                [UserDefaluts setObject:@"Beginner" forKey:kUserLevel];
                break;
            case 1:
                [UserDefaluts setObject:@"Intermediate" forKey:kUserLevel];
                break;
            case 2:
                [UserDefaluts setObject:@"Advanced" forKey:kUserLevel];
                break;
            default:
                break;
        }
        
        [UserDefaluts synchronize];
    
    }
    
}
- (void) isPickerNotif:(id)sender
{
   
    NWPickerField *pickerField = (NWPickerField*)sender;
    activePickerField = pickerField;
	if(toolbar)
        [toolbar removeFromSuperview];
    toolbar = [[Common sharedInstance] returnToolbar:pickerField.tag frame:CGRectMake(0.0,
                                                                                    200,
                                                                                    320,
                                                                                    44)];
//    toolbar.frame = CGRectMake(0.0,200, 320,44);
    toolbar.tag = 0;
    [Common sharedInstance].pickerDelegate = self;
    [self.view addSubview:toolbar];
    
    NSString *strTag = [NSString stringWithFormat:@"%d", pickerField.tag];
    NSString *section = @"0";
    NSString *row = @"0";
    if([strTag length]>1)
    {
        section = [strTag substringWithRange:NSMakeRange(0, [strTag length]-1)];
        row = [strTag substringFromIndex:1];
    }
    else
        row = strTag;
    
    tblLanguageList.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0);
    
}


-(void) closePickerView:(id)sender
{
    
}
-(void) nextPreviousPicker:(id)sender tag:(NSInteger)tag
{
    
}

- (void)onlyForDemoWithString:(NSString*)countryName
{
    if ([countryName isEqualToString:NSLocalizedString(@"English", nil)]) {
        
        [arrTargetLanguages removeAllObjects];
        [arrTargetLanguages addObjectsFromArray:[NSArray arrayWithObjects:NSLocalizedString(@"Arabic", nil),NSLocalizedString(@"Chinese", nil),NSLocalizedString(@"French", nil),NSLocalizedString(@"German", nil),NSLocalizedString(@"Italian", nil),NSLocalizedString(@"Japanese", nil),NSLocalizedString(@"Korean", nil),NSLocalizedString(@"Portuguese", nil),NSLocalizedString(@"Russian", nil),NSLocalizedString(@"Spanish", nil),nil]];
        
    } else {
        
        [arrTargetLanguages removeAllObjects];
        [arrTargetLanguages addObject:NSLocalizedString(@"English", nil)];
        
    }
}

#pragma mark - Toolbar delegate
-(void) closePicker:(NSInteger)tag
{
    NSLog(@"CLOSE PICKER %d %d",tag,[activePickerField selectedRowInComponent:0]);
    
    [toolbar removeFromSuperview];
    [activeField resignFirstResponder];
    [activePickerField hide];
    [activePickerField selectRow:[activePickerField selectedRowInComponent:0] inComponent:0 animated:NO];
    
    if(tag == 2)
    {
        
        // Normal condtion
        
        NSInteger row = [activePickerField selectedRowInComponent:0];
        
        [arrTargetLanguages removeAllObjects];
        arrTargetLanguages = [arrLanguages mutableCopy];
        NSInteger index = [arrLanguages indexOfObject:activePickerField.text];
        
        [activePickerField setText:NSLocalizedString([arrTargetLanguages objectAtIndex:row], nil)];
        
        [arrTargetLanguages removeObjectAtIndex:index];
        
        
        [self onlyForDemoWithString:activePickerField.text];
        
         
        NSString *nativelangCode = [self getLanguageCode:[arrLanguages objectAtIndex:row]];
        //NSMutableArray *arrLangCode = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Language WHERE languageName = '%@'",activePickerField.text] withField:@"languageCode"];
        //[UserDefaluts setObject:[arrLangCode objectAtIndex:0] forKey:kNativeLangCode];
        [UserDefaluts setObject:nativelangCode forKey:kNativeLangCode];
        [UserDefaluts synchronize];
        
        if (![activePickerField.text isEqualToString:NSLocalizedString(@"English", nil)]) {
            
            [targetPickerField setText:NSLocalizedString(@"English", nil)];
            [UserDefaluts setObject:@"en" forKey:kTargetLangCode];
            [UserDefaluts synchronize];
            
        } else {
            
            [targetPickerField setText:NSLocalizedString(@"Arabic", nil)];
            [UserDefaluts setObject:@"ar" forKey:kTargetLangCode];
            [UserDefaluts synchronize];
        }
        
        
        // Build for WordReference
        /*
        [arrTargetLanguages removeAllObjects];
        arrTargetLanguages = [arrLanguages mutableCopy];
        NSInteger index = [arrLanguages indexOfObject:activePickerField.text];
        [arrTargetLanguages removeObjectAtIndex:index];
        
        NSMutableArray *arrLangCode = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Language WHERE languageName = '%@'",activePickerField.text] withField:@"languageCode"];
        [UserDefaluts setObject:[arrLangCode objectAtIndex:0] forKey:kNativeLangCode];
        [UserDefaluts synchronize];
         */
        
    }
    else if(tag == 3)
    {
        NSInteger row = [activePickerField selectedRowInComponent:0];
        NSLog(@"selected row and array index is %d %@",row,[arrTargetLanguages objectAtIndex:row]);
        
        [activePickerField setText:NSLocalizedString([arrTargetLanguages objectAtIndex:row], nil)];
        [targetPickerField setText:NSLocalizedString([arrTargetLanguages objectAtIndex:row], nil)];
        
        NSString *targetLangCode = [self getLanguageCode:[arrTargetLanguages objectAtIndex:row]];
        //NSMutableArray *arrLangCode = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Language WHERE languageName = '%@'",activePickerField.text] withField:@"languageCode"];
        
        [UserDefaluts setObject:targetLangCode forKey:kTargetLangCode];
        //[UserDefaluts setObject:[arrLangCode objectAtIndex:0] forKey:kTargetLangCode];
        [UserDefaluts synchronize];
        
    } else if (tag == 4) {
        
        NSLog(@"%@",activePickerField.text);
        //[UserDefaluts setObject:activePickerField.text forKey:kUserLevel];
        //[UserDefaluts synchronize];
        NSInteger row = [activePickerField selectedRowInComponent:0];
        NSLog(@"row is %d",row);
        switch (row) {
            case 0:
                [UserDefaluts setObject:@"Beginner" forKey:kUserLevel];
                break;
            case 1:
                [UserDefaluts setObject:@"Intermediate" forKey:kUserLevel];
                break;
            case 2:
                [UserDefaluts setObject:@"Advanced" forKey:kUserLevel];
                break;
            default:
                break;
        }
        
        [UserDefaluts synchronize];
        NSLog(@"%@",activePickerField.text);
    }
    
    tblLanguageList.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSLog(@"native code = %@  target code = %@",[UserDefaluts objectForKey:kNativeLangCode],[UserDefaluts objectForKey:kTargetLangCode]);
    
}

- (NSString *)getLanguageCode:(NSString*)cuntryName
{
    // NSLog(@"%@",NSLocalizedStringFromTableInBundle(@"English", nil,[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"fr" ofType:@"lproj"]], @""));
    //[UserDefaluts objectForKey:kUserLevel]
    
    if ([cuntryName isEqualToString:NSLocalizedString(@"English", nil)]) {
        return @"en";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Arabic", nil)]) {
        return @"ar";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Spanish", nil)]) {
        return @"es";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Chinese", nil)]) {
        return @"zh";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"German", nil)]) {
        return @"de";
    } if ([cuntryName isEqualToString:NSLocalizedString(@"French", nil)]) {
        return @"fr";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Italian", nil)]) {
        return @"it";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Japanese", nil)]) {
        return @"ja";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Korean", nil)]) {
        return @"ko";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Portuguese", nil)]) {
        return @"pt";
    } else if ([cuntryName isEqualToString:NSLocalizedString(@"Russian", nil)]) {
        return @"ru";
    } else {
        return nil;
    }
    
    
}


- (void)nextField:(NSInteger)tag
{
    
}
- (void)previousField:(NSInteger)tag
{
    
    
}
- (void)cancelPicker:(NSInteger)tag
{
    
}

//get languagename through language code
-(NSString *) getLanguageNameThroughCode:(NSString *) code
{
    NSMutableArray *arrName = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Language WHERE languageCode = '%@'", code] withField:@"languageName"];
    if([arrName count]>0)
        return [arrName objectAtIndex:0];
    return nil;
}

//install preinstalled words
-(void) insertPreinstalledWords
{
    
    NSString *nativeLang = [self getLanguageNameThroughCode:[UserDefaluts valueForKey:kNativeLangCode]];
    NSString *targetLang = [self getLanguageNameThroughCode:[UserDefaluts valueForKey:kTargetLangCode]];
     
    NSString *tableName = nil;
    if ([[UserDefaluts objectForKey:kUserLevel] isEqualToString:@"Advanced"]) {
        tableName = @"tbl_Words_Advanced";
    } else if ([[UserDefaluts objectForKey:kUserLevel] isEqualToString:@"Intermediate"]) {
        
        tableName = @"tbl_Words_Intermediate";
        
    } else {
        tableName = @"tbl_Words";
    }
    
   // NSLog(@" print detial NC=  %@ , TC =  %@ , UL= %@ , TN = %@",[UserDefaluts objectForKey:kNativeLangCode],[UserDefaluts objectForKey:kTargetLangCode],[UserDefaluts objectForKey:kUserLevel],tableName);
    
    //return;
    
    NSDate *currentDate = [NSDate date];
    NSMutableArray *arrWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:tableName withField:[NSString stringWithFormat:@"\"%@\",\"%@\"",nativeLang,targetLang]];
    
    NSString *multipleRowData = @"insert into tbl_Dictionary (targetWord,nativeWord,bucketColor,nativeLanguage,targetLanguage,action,userLevel,sense,POS,dateOfTest) ";
    
    NSString *strUnion = @"";
    for(int i=0;i<[arrWords count];i++)
    {
        
        NSArray *arrLan = [[arrWords objectAtIndex:i] componentsSeparatedByString:@"/|"];
        //if(i>=0 && i<15)
        strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, '%@' as bucketColor, '%@' as nativeLanguage, '%@' as targetLanguage, '%@' as action, '%@' as userLevel, '%@' as sense, '%@' as POS, '%@' as dateOfTest union ",[arrLan objectAtIndex:1],[arrLan objectAtIndex:0],@"White",[UserDefaluts valueForKey:@"nativeLanguageCode"],[UserDefaluts valueForKey:kTargetLangCode],@"Saved",[UserDefaluts objectForKey:kUserLevel],@"",@"",currentDate]];
        
        
        //For Orange test 1
        //if(i>=15 && i<30)
        //if(i<=25)
        //strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, '%@' as bucketColor, '%@' as nativeLanguage, '%@' as targetLanguage, '%@' as action, '%@' as userLevel, '%@' as sense, '%@' as POS, '%@' as dateOfTest union ",[arrLan objectAtIndex:1],[arrLan objectAtIndex:0],@"Orange",[UserDefaluts valueForKey:kNativeLangCode],[UserDefaluts valueForKey:kTargetLangCode],@"WhiteTest2",[UserDefaluts objectForKey:kUserLevel],@"",@"",currentDate]];
        //For Orange test 2
        //if(i>25)
        //strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, '%@' as bucketColor, '%@' as nativeLanguage, '%@' as targetLanguage, '%@' as action, '%@' as userLevel, '%@' as sense, '%@' as POS, '%@' as dateOfTest union ",[arrLan objectAtIndex:1],[arrLan objectAtIndex:0],@"Orange",[UserDefaluts valueForKey:kNativeLangCode],[UserDefaluts valueForKey:kTargetLangCode],@"OrangeTest1",[UserDefaluts objectForKey:kUserLevel],@"",@"",currentDate]];
        
        // For Green test
        //if(i>=30&&i<45)
        //strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, '%@' as bucketColor, '%@' as nativeLanguage, '%@' as targetLanguage, '%@' as action, '%@' as userLevel, '%@' as sense, '%@' as POS, '%@' as dateOfTest union ",[arrLan objectAtIndex:1],[arrLan objectAtIndex:0],@"Green",[UserDefaluts valueForKey:@"nativeLanguageCode"],[UserDefaluts valueForKey:@"targetLanguageCode"],@"OrangeTest2",[UserDefaluts objectForKey:kUserLevel],@"",@"",currentDate]];
        
        //if(i>=45)
        //For Red Test
        //strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, '%@' as bucketColor, '%@' as nativeLanguage, '%@' as targetLanguage, '%@' as action, '%@' as userLevel, '%@' as sense, '%@' as POS, '%@' as dateOfTest union ",[arrLan objectAtIndex:1],[arrLan objectAtIndex:0],@"Red",[UserDefaluts valueForKey:@"nativeLanguageCode"],[UserDefaluts valueForKey:kTargetLangCode],@"WhiteTest1",[UserDefaluts objectForKey:kUserLevel],@"",@"",currentDate]];
    }
    
    if([strUnion length]>0)
        multipleRowData = [multipleRowData stringByAppendingString:[strUnion substringToIndex:[strUnion length]-6]];
    
    [[DBHelper sharedDbInstance] insertMultipleRows:multipleRowData];

}

//done clicked
-(IBAction)finish:(id)sender
{
    if([[UserDefaluts valueForKey:kNativeLangCode] isEqualToString:[UserDefaluts valueForKey:kTargetLangCode]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Your native language and the language you're learning can not be the same.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if(txtName)
            [UserDefaluts setObject:txtName.text forKey:@"UserName"];
        [self insertPreinstalledWords];
        //return;
        [UserDefaluts setBool:YES forKey:@"loginDone"];
        [UserDefaluts synchronize];
        NSString *nib = SharedAppDelegate.isPhone5 ? @"InfoViewC" : @"InfoViewCiPhone4";
        InfoViewC *infoObject = [[InfoViewC alloc] initWithNibName:nib bundle:nil];
        infoObject.isFromLogin = YES;
        [self.navigationController pushViewController:infoObject animated:YES];
        //[SharedAppDelegate showTabBar];
        //[self dismissModalViewControllerAnimated:YES];
        
        [SharedAppDelegate.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User_Login" action:@"Login_Action" label:@"WordBucket-Paid" value:nil] build]];
       
    }    
}



-(void) chooseFromGallery:(id)sender
{
    
    [toolbar removeFromSuperview];
    [activeField resignFirstResponder];
    [activePickerField hide];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate=self;
    imagePicker.allowsEditing=NO;
    //Show image picker
    [self presentModalViewController:imagePicker animated:YES];

   
}

#pragma UIImagePickerController delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if(![self isViewLoaded])
		[self view];
    
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *avatar = [Common generatePhotoThumbnail:image];
    NSString  *pngPath = [[[Common sharedInstance] getDatabasePath] stringByAppendingPathComponent:@"avatar.png"];
	[UIImagePNGRepresentation(avatar) writeToFile:pngPath atomically:YES];
    
    self.imageAvatar.image = avatar;
    [self.imageAvatar setContentMode:UIViewContentModeScaleToFill];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    
    [self setTermsAndCond:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}


@end
