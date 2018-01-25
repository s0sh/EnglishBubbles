//
//  CreditViewC.m
//  WordBucket
//
//  Created by ashish on 3/7/13.
//  Copyright (c) 2013 Mehak Bhutani. All rights reserved.
//

#import "CreditViewC.h"

@interface CreditViewC ()

@end

@implementation CreditViewC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setLocalizedString
{
    [_titleLabel setText:NSLocalizedString(@"Word Bucket Credits", nil)];
    [_wbsupportedbyTxt setText:NSLocalizedString(@"Word Bucket is supported by:", nil)];
}

- (void)viewDidLoad
{
    
    [self setLocalizedString];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureCreditText];
    //[_scrollView setContentSize:CGSizeMake(293, 947)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"Credit Screen";
}


- (CGSize)getSizeWithString:(NSString*)string withFont:(UIFont*)font
{
    CGSize constraint = CGSizeMake(272, 2000.0f);
    CGSize size = [string sizeWithFont:font
                              constrainedToSize:constraint
                                  lineBreakMode:UILineBreakModeWordWrap];
    return size;
}

- (void)configureCreditText
{
    
    
    NSString *localizedCredit = NSLocalizedString(@"This project received grant aid from Galway Rural Development Company Ltd., which is financed by the Irish Government under the Rural Development Programme Ireland 2007-2013 and by the European Agricultural Fund for the Rural Development Programme (EARDF): Europe investing in Rural Areas.", nil);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    
    CGSize size = [self getSizeWithString:localizedCredit withFont:font];
    

    UILabel *creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 284, size.width, size.height)];
    [creditLabel setText:localizedCredit];
    [creditLabel setTextColor:[UIColor blackColor]];
    [creditLabel setFont:font];
    [creditLabel setNumberOfLines:0];
    [creditLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:creditLabel];
    
    NSInteger yValue = 284 + size.height + 10;
    
    NSString *specialThanksStr = NSLocalizedString(@"A special thanks to:", nil);
    
    UIFont *tFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    CGSize sizeThanksLbl = [self getSizeWithString:specialThanksStr withFont:tFont];
    UILabel *thanksLabel = [Common createNewLabelWithTag:20 WithFrame:CGRectMake(9, yValue, sizeThanksLbl.width, sizeThanksLbl.height) text:specialThanksStr noOfLines:0 color:[UIColor blueColor] withFont:tFont];
    
    [self.scrollView addSubview:thanksLabel];
    
    yValue = yValue+ sizeThanksLbl.height + 10;
    
    
    NSString *peopleString = @"Bram Zwimmen, Antonio Roa Valverde, Jose Luis Guerrero Marin, Antonio Otero Andria, Aleksey 'Alex' Nitsenko, Ashish Chauhan, Deepti Singh, John Power, Michael Hanley, Jason Leonard, Richard Coen of Emarkable, Keelin Mc Loughlin, Liam Bluett, Kholoud Youssef, Ivy Feng, Mohammed Ahmed Mostafa, Pierre Toury, Caridad Castro Perez, Ooi L. Lee, Tanja Lauinger, Melania Martinez Diaz, Eamon de Staic, William Curtis, Adam Lofting, Kevin Killick, Kim Karim, Rachelle Kesset, Анна Ефремова, Lorraine Musani, Egor Homakov, Annabelle West, Andrew Lloyd, Michael Hopkins, Simon Jones, Luz Mari Castro, Kiara Mills, David Colmonero, Gada Alumny, Carles Sentis, Amit Garg, Mehak and all the guys at TechAhead.";
    
    CGSize peopleSize = [self getSizeWithString:peopleString withFont:font];
    
    UILabel *peopleLabel = [Common createNewLabelWithTag:21 WithFrame:CGRectMake(9, yValue, peopleSize.width, peopleSize.height) text:peopleString noOfLines:0 color:[UIColor blackColor] withFont:font];
    [self.scrollView addSubview:peopleLabel];
    
    yValue = yValue+ peopleSize.height + 10;
    
    UILabel *englilsLbl = [Common createNewLabelWithTag:22 WithFrame:CGRectMake(4, yValue, 284, 21) text:@"Word Bucket™ is an English Bubble product." noOfLines:1 color:[UIColor blackColor] withFont:font];
    [self.scrollView addSubview:englilsLbl];
    
    UILabel *blueLabel = [Common createNewLabelWithTag:23 WithFrame:CGRectMake(133, yValue+20, 95, 2) text:@"" noOfLines:1 color:[UIColor clearColor] withFont:font];
    [blueLabel setBackgroundColor:[UIColor blueColor]];
    [self.scrollView addSubview:blueLabel];
    
    UIButton *englishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [englishButton setFrame:CGRectMake(135, yValue, 95, 21)];
    [englishButton addTarget:self action:@selector(englishButtonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[englishButton setBackgroundColor:[UIColor redColor]];
    //[englishButton setAlpha:0.5];
    [self.scrollView addSubview:englishButton];
    
    yValue = yValue + 31;
    
    //Service Label
    NSString *serviceString = NSLocalizedString(@"Word Bucket Dictionaries & translation services", nil);
    CGSize serviceStrSize = [self getSizeWithString:serviceString withFont:tFont];
    
    UILabel *serviceLabel = [Common createNewLabelWithTag:23 WithFrame:CGRectMake(9, yValue, serviceStrSize.width, serviceStrSize.height) text:serviceString noOfLines:0 color:[UIColor blackColor] withFont:tFont];
    [self.scrollView addSubview:serviceLabel];
    
    yValue = yValue+ serviceStrSize.height + 10;
    
    NSString *wikiString = NSLocalizedString(@"Word Bucket is powered by a selection of commercial and open source dictionaries and translation services including <a href = \"http://www.wiktionary.org/\"> Wiktionary </a>, licensed under the <a href=\"https://creativecommons.org/licenses/by-sa/3.0/\"> Creative Commons Attribution-ShareAlike</a> license. For more information on the use of these dictionaries see our <a href=\"https://wordbucket.com/en/terms-of-service\">; Terms of Service</a>. ", nil);
    NSString *loadString = [NSString stringWithFormat:@"<html><head><style>body {background:transparent; font-family:Helvetica; color: #3C515C; font-size:15px} p {color:black;}</style></head><body><p>%@<p></body></html>", wikiString];
    CGSize wikiStrSize = [self getSizeWithString:wikiString withFont:font];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(9, yValue, wikiStrSize.width, wikiStrSize.height)];
    [webView setDelegate:self];
    [webView loadHTMLString:loadString baseURL:nil];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    [self.scrollView addSubview:webView];
    
    yValue = yValue+ wikiStrSize.height;

    
    //UIImageView *blueBarImgView = [[UIImageView alloc] initWithImage:GetImage(@"bottomcolor@2x")];
    //[blueBarImgView setFrame:CGRectMake(0, yValue, 293, 2)];
    //[self.scrollView addSubview:blueBarImgView];
    
    [_scrollView setContentSize:CGSizeMake(293, yValue+2)];
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

- (IBAction)homeBucketClickd:(id)sender {
    
    // Back to previous view
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setTitleLabel:nil];
    [self setWbsupportedbyTxt:nil];
    [super viewDidUnload];
}
- (IBAction)englishButtonButtonClicked:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.englishbubble.com"]];
}
@end
