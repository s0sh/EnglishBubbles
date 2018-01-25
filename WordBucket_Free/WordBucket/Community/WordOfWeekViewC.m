//
//  WordOfWeekViewC.m
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "WordOfWeekViewC.h"
#import "TFHpple.h"
#import "SearchVC.h"

@interface WordOfWeekViewC ()

@end

@implementation WordOfWeekViewC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIFont*)getFontWithString:(NSString*)string withHeight:(CGFloat)ht withWidth:(CGFloat)wd
{
    CGSize constraint = CGSizeMake(wd, 2000.0f);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    NSInteger finalFont = 13;
    for (int k = 15; k >1; k--) {
        CGSize size = [string sizeWithFont: [UIFont fontWithName:@"Helvetica-Bold" size:k]
                         constrainedToSize:constraint
                             lineBreakMode:UILineBreakModeWordWrap];
        
        if (size.height <= ht) {
            finalFont = k;
            break;
        }
        
    }
    
    return [font fontWithSize:finalFont];
}


- (void)setLocalizedString
{
    [_titleLabel setText:NSLocalizedString(@"Words Of The Week", nil)];
    [_fivewordLabel setText:NSLocalizedString(@"Each week we pick 5 Words of the Week. Have you got these in your Word Bucket?", nil)];
    [_fivewordLabel setFont:[self getFontWithString:_fivewordLabel.text withHeight:46 withWidth:_fivewordLabel.frame.size.width]];
}


#pragma mark -- Html parsing 
- (void)parseHtml
{
    //http://wordbucket.com/en/feed/
    //NSURL *htmlUrl = [NSURL URLWithString:@"http://englishbubble.com/words-of-the-week-22/?utm_source=rss&utm_medium=rss&utm_campaign=words-of-the-week-22"];
    
    //NSURL *htmlUrl = [NSURL URLWithString:@"http://www.wordbucket.com/en/words-of-the-week-1/"];
    NSURL *htmlUrl = [NSURL URLWithString:_htmlurlString];
    NSData *htmlData = [NSData dataWithContentsOfURL:htmlUrl];
    TFHpple *hppleParser = [TFHpple hppleWithHTMLData:htmlData];
    
    //NSString *nameXpathQueryString = @"//h3[@itemprop='name']";
    NSString *nameXpathQueryString = @"//h3[@itemprop='name']";
    NSArray *nameNodes = [hppleParser searchWithXPathQuery:nameXpathQueryString];
    for (TFHppleElement *element in nameNodes) {
        NSLog(@"name = %@",[[element firstChild] content]);
        [_nameArray addObject:[[element firstChild] content]?[[element firstChild] content]:@""];
        
    }
    //span[@itemprop='Description']
    NSString *descXpathQueryString = @"//span[@itemprop='Description']";
    NSArray *desctutorialsNodes = [hppleParser searchWithXPathQuery:descXpathQueryString];
    for (TFHppleElement *element in desctutorialsNodes) {
        
        @try {
            
            TFHppleElement *elementdic1 =[[element children] objectAtIndex:1];
            
            [_descArray addObject:[elementdic1 content]?[elementdic1 content]:@""];
        }   
        @catch (NSException *exception) {
        [_descArray addObject:@""];
        }
        
        @try {
            
            TFHppleElement *elementdic2 =[[element children] objectAtIndex:2];
            
            [_detailArray addObject:[[elementdic2 firstChild] content]?[[elementdic2 firstChild] content]:@""];
        }
        @catch (NSException *exception) {
            [_detailArray addObject:@""];
        }
        
    }
    
    //NSString *descXpathQueryString = @"//span[@itemprop='Description']";
    NSString *commentXpathQueryString = @"//span[@itemprop='comment']";
    NSArray *commenttutorialsNodes = [hppleParser searchWithXPathQuery:commentXpathQueryString];
    for (TFHppleElement *element in commenttutorialsNodes) {
        NSLog(@"name = %@",[[element firstChild] content]);
        [_commentArray addObject:[[element firstChild] content]?[[element firstChild] content]:@""];
        
    }
    
    
    NSString *imgXpathQueryString = @"//img[@itemprop='image']";
    NSArray *imgtutorialsNodes = [hppleParser searchWithXPathQuery:imgXpathQueryString];
    for (TFHppleElement *element in imgtutorialsNodes) {
        NSLog(@"name = %@",[element attributes]);
        [_imgArray addObject:[[element attributes] objectForKey:@"src"]?[[element attributes] objectForKey:@"src"]:@""];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLocalizedString];
    
    
    _nameArray = [[NSMutableArray alloc] init];
    _descArray = [[NSMutableArray alloc] init];
    _imgArray = [[NSMutableArray alloc] init];
    _detailArray = [[NSMutableArray alloc] init];
    _commentArray = [[NSMutableArray alloc] init];
    
    [[Common sharedInstance] showActivityIndicator:self];
    [self performSelector:@selector(callHTMLApi) withObject:nil afterDelay:0.2];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Word of The Week Detail Screen";
}


- (void)callHTMLApi
{
    [self parseHtml];
    [self addNulValues];
    [self.wordListTable reloadData];
    [self.wordListTable setContentOffset:CGPointMake(0, 0)];
    [[Common sharedInstance] stopActivityIndicator:self];
}

- (void)addNulValues
{
   
    _cachesImagesArray=nil;
    _cachesImagesArray = [[NSMutableArray alloc] init];
    for(int i=0;i<[_nameArray count];i++)
        [_cachesImagesArray addObject:[NSNull null]];
        

}
- (IBAction)homeButtonClicked:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -- UITableView datasource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    return [_nameArray count];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *descString = [_descArray objectAtIndex:indexPath.row];
    descString = [descString stringByTrimmingLeadingWhitespaceAndNewline];
    
    NSString *commentString = [_commentArray objectAtIndex:indexPath.row];
    commentString = [commentString stringByTrimmingLeadingWhitespaceAndNewline];
    NSString *detailString = [_detailArray objectAtIndex:indexPath.row];
    detailString = [detailString stringByTrimmingLeadingWhitespaceAndNewline];
    
    NSString *finalString = nil;
    if (detailString.length>0) {
        finalString = [NSString stringWithFormat:@"%@\n%@\n%@",descString,detailString,commentString];
    } else {
        
        finalString = [NSString stringWithFormat:@"%@\n%@",descString,commentString];
    }
    
    CGSize size = [finalString sizeWithFont:[UIFont systemFontOfSize:15]
                         constrainedToSize:CGSizeMake(193, MAXFLOAT)
                             lineBreakMode:UILineBreakModeWordWrap];
    
    return (size.height+43) > 75 ? (size.height+43) : 75;
}   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"WordOfWeekCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
 
    }
    
    */
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CGRect cellFrame = [tableView rectForRowAtIndexPath:indexPath];
    
    UIImageView *imgViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(12, 1, 297, cellFrame.size.height-2)];
    [imgViewLine setImage:GetImage(@"settingcontainer")];
    [imgViewLine setContentMode:UIViewContentModeScaleToFill];
    [cell.contentView addSubview:imgViewLine];
    
    UIImageView *itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(29, 8, 66, 44)];
    [itemImage setImage:GetImage(@"imagebox")];
    [cell.contentView addSubview:itemImage];
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(106, 8, 161, 21)];
    [nameLable setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [nameLable setText: (indexPath.row < _nameArray.count) ? [_nameArray objectAtIndex:indexPath.row] : @""];
    [cell.contentView addSubview:nameLable];
    
    UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(106, 37, 193, 21)];
    [detailLable setFont:[UIFont systemFontOfSize:14]];
    [detailLable setNumberOfLines:0];
    [cell.contentView addSubview:detailLable];
    
    NSString *descString = (indexPath.row < _descArray.count) ? [_descArray objectAtIndex:indexPath.row] : @"";
    
    descString = [descString stringByTrimmingLeadingWhitespaceAndNewline];
    
    NSString *commentString = [_commentArray objectAtIndex:indexPath.row];
    commentString = [commentString stringByTrimmingLeadingWhitespaceAndNewline];
    
    NSString *detailString = (indexPath.row < _detailArray.count) ? [_detailArray objectAtIndex:indexPath.row] : @"";
    detailString = [detailString stringByTrimmingLeadingWhitespaceAndNewline];
    
    NSString *finalString = nil;
    if (detailString.length>0) {
        finalString = [NSString stringWithFormat:@"%@\n%@\n%@",descString,detailString,commentString];
    } else {
        
        finalString = [NSString stringWithFormat:@"%@\n%@",descString,commentString];
    }
    CGSize size = [finalString sizeWithFont:[UIFont systemFontOfSize:14]
                          constrainedToSize:CGSizeMake(193, MAXFLOAT)
                              lineBreakMode:UILineBreakModeWordWrap];
    [detailLable setText:finalString];
    CGRect frame = detailLable.frame;
    frame.size.height = size.height;
    [detailLable setFrame:frame];
    
    
    @try {
        
        
    //UIImageView *itemImage = (UIImageView*)[cell.contentView viewWithTag:100];
    if([_cachesImagesArray objectAtIndex:indexPath.row] != [NSNull null])
    {
        itemImage.image  = [_cachesImagesArray objectAtIndex:indexPath.row];
        NSLog(@"existing");
    }
    else
    {
        NSString *strImgURl = [_imgArray objectAtIndex:indexPath.row];
        NSLog(@"fetch from server");
        NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
        [data setObject:[NSString stringWithFormat:@"%i",indexPath.row] forKey: @"rowVal"];
        [data setObject:itemImage forKey: @"imageView"];
        if (strImgURl) {
            [data setObject:strImgURl forKey:@"imageUrl"];
        } else {
            [data setObject:@"0" forKey:@"imageUrl"];
        }
        [NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:data];
    }
        
    }
    @catch (NSException *exception) {
        // When exception occure
        UIImage *imgBox = GetImage(@"imagebox");
        itemImage.image = imgBox;
    }

    
     
    return cell;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *wordLable = (UILabel*)[cell.contentView viewWithTag:101];
    SharedAppDelegate.isNativeSrchLang = YES;
    if([[Common sharedInstance] checkInternetConnection])
    {
        NSString *nib = SharedAppDelegate.isPhone5 ? @"SearchVC" : @"SearchVCiPhone4";
        SearchVC *search = [[SearchVC alloc] initWithNibName:nib bundle:[NSBundle mainBundle]];
        search.strSearchWord = [wordLable.text lowercaseString];
        [self.navigationController pushViewController:search animated:YES];
        
    }
    else
    {
        [Common showAlertView:nil message:@"No internet connection!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchImage:(NSMutableDictionary *)dict
{
	
    int  photoId = [[dict objectForKey:@"rowVal"] intValue];
    NSString *imgURl = [dict objectForKey:@"imageUrl"];
	
	NSData *mydata = nil;
    mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgURl]];
	
	UIImage *myImage;
	
    if(mydata)
	{
		myImage = [[UIImage alloc] initWithData:mydata];
		[(UIImageView *)[dict objectForKey:@"imageView"] setImage:myImage];
        
        if(_cachesImagesArray.count > photoId && myImage != nil)
            [_cachesImagesArray replaceObjectAtIndex:photoId withObject:myImage];
        
	} else {
        
        UIImage *myImage1 = GetImage(@"imagebox");//[UIImage imageNamed:@"user.png"];
        [(UIImageView *)[dict objectForKey:@"imageView"] setImage:myImage1];
        
        if(_cachesImagesArray.count > photoId && myImage1 != nil)
            [_cachesImagesArray replaceObjectAtIndex:photoId withObject:myImage1];
    }
}



- (void)viewDidUnload {
    [self setWordListTable:nil];
    [self setTitleLabel:nil];
    [self setFivewordLabel:nil];
    [self setCommentArray:nil];
    [self setImgArray:nil];
    [self setDescArray:nil];
    [self setNameArray:nil];
    [super viewDidUnload];
}
@end
