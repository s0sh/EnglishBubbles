//
//  WordOfWeekListViewC.m
//  WordBucket
//
//  Created by ashish on 4/12/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "WordOfWeekListViewC.h"
#import "TFHpple.h"
#import "WordOfWeekViewC.h"

@interface WordOfWeekListViewC ()

@end

@implementation WordOfWeekListViewC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)parseXML
{
    
    
    NSURL *tutorialsUrl = [NSURL URLWithString:@"http://wordbucket.com/en/feed/"];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    TFHpple *imgParser = [TFHpple hppleWithXMLData:tutorialsHtmlData];
    NSString *imgXpathQueryString = @"/rss/channel/item/title";
    NSArray *imgtutorialsNodes = [imgParser searchWithXPathQuery:imgXpathQueryString];
    for (TFHppleElement *element in imgtutorialsNodes) {
        NSLog(@"name = %@",[[element firstChild] content]);
        [_weekListArray addObject:[[element firstChild] content]?[[element firstChild] content]:@""];
    }
    
    NSString *linkXpathQueryString = @"/rss/channel/item/link";
    NSArray *linktutorialsNodes = [imgParser searchWithXPathQuery:linkXpathQueryString];
    for (TFHppleElement *element in linktutorialsNodes) {
        NSLog(@"name = %@",[[element firstChild] content]);
        [_linkListArray addObject:[[element firstChild] content]?[[element firstChild] content]:@""];
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_titleLabel setText:NSLocalizedString(@"Words Of The Week", nil)];
    _weekListArray = [[NSMutableArray alloc] init];
    _linkListArray = [[NSMutableArray alloc] init];
    [[Common sharedInstance] showActivityIndicator:self];
    [self performSelector:@selector(callXMLService) withObject:nil afterDelay:0.2];
    
    NSLog(@"count is %d %d",_weekListArray.count,_linkListArray.count);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Word of The Week List Screen";
}


- (void)callXMLService
{
    [self parseXML];
    [self.weekListTable reloadData];
    [[Common sharedInstance] stopActivityIndicator:self];
}

#pragma mark -- UITableView datasource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    return [_weekListArray count];
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    [cell.textLabel setText:[_weekListArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nib = SharedAppDelegate.isPhone5 ? @"WordOfWeekViewC" : @"WordOfWeekViewCiPhone4";
    WordOfWeekViewC *wordweekObj = [[WordOfWeekViewC alloc] initWithNibName:nib bundle:nil];
    wordweekObj.htmlurlString = [_linkListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:wordweekObj animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setWeekListArray:nil];
    [self setWeekListTable:nil];
    [super viewDidUnload];
}
@end
