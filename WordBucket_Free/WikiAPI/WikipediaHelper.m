

#import "WikipediaHelper.h"
//#import "SBJsonParser.h"
#import "AppDelegate.h"

@implementation WikipediaHelper
@synthesize apiUrl, imageBlackList;

- (id)init {
    self = [super init];
    if (self) {
        // Standard values for the api URL
        // EN
        apiUrl = @"http://en.wiktionary.org";
        
        // DE
        // apiUrl = @"http://de.wikipedia.org";
        
        
        imageBlackList = [[NSMutableArray alloc] init];
        [imageBlackList addObject:@"http://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Padlock-silver.svg/20px-Padlock-silver.svg.png"];
        [imageBlackList addObject:@"http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Disambig-dark.svg/25px-Disambig-dark.svg.png"];
        [imageBlackList addObject:@"http://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Qsicon_L%C3%BCcke.svg/24px-Qsicon_L%C3%BCcke.svg.png"];
        [imageBlackList addObject:@"http://upload.wikimedia.org/wikipedia/en/thumb/9/94/Symbol_support_vote.svg/15px-Symbol_support_vote.svg.png"];
        [imageBlackList addObject:@"http://upload.wikimedia.org/wikipedia/en/f/f4/Ambox_content.png"];
        [imageBlackList addObject:@"http://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Crystal_Clear_app_kedit.svg/40px-Crystal_Clear_app_kedit.svg.png"];
        [imageBlackList addObject:@"http://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Text_document_with_red_question_mark.svg/40px-Text_document_with_red_question_mark.svg.png"];
    }
    return self;
}

- (NSString *) getWikipediaArticle:(NSString *)name {
    // Create new SBJSON parser object
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // JSON Request url
    NSURLRequest *request;
    
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/w/api.php?action=query&prop=revisions&titles=%@&rvprop=content&rvparse&format=json&redirects", apiUrl, name];
//    NSString *url = [[NSString alloc] initWithFormat:@"%@/w/api.php?action=query&prop=iwlinks&titles=%@&format=json&iwlimit=60", apiUrl, name];
    NSString *url = [[NSString alloc] initWithFormat:@"%@/w/api.php?action=query&prop=langlinks&titles=%@&format=json", apiUrl, name];
    
//action: 'query',
//prop: 'iwlinks',
//format: 'json',
//iwlimit: 30,
//iwprefix: $('#to').val(),
//titles: $('#word').val()
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"json: %@",json_string);
    // parse the JSON response into an object
    // Here we're using NSArray since we're parsing an array of JSON status objects
    NSDictionary *wikipediaResponseObject = [parser objectWithString:json_string];
    
    NSArray *htmlTemp = [[[wikipediaResponseObject objectForKey:@"query"] objectForKey:@"pages"] allValues];
    
    if(![[htmlTemp objectAtIndex:0] objectForKey:@"revisions"]) {
        return @"";
    }
    
    NSString *htmlSrc = [[[[htmlTemp objectAtIndex:0] objectForKey:@"revisions"] objectAtIndex:0] objectForKey:@"*"];
    
    return htmlSrc;
}
- (NSMutableArray *) getWikipediaTranslation:(NSString *)name search:(BOOL)isSearchNative {
    // Create new SBJSON parser object
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // JSON Request url
    NSURLRequest *request;
    
    //http://en.wiktionary.org/w/api.php?action=query&prop=iwlinks&format=json&iwlimit=30&iwprefix=es&titles=hello
    NSString *lanCode = isSearchNative ? [UserDefaluts objectForKey:kNativeLangCode ]:[UserDefaluts objectForKey:kTargetLangCode];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/w/api.php?action=query&prop=iwlinks&format=json&iwlimit=30&iwprefix=%@&titles=%@", apiUrl,lanCode, name];
    NSString *properlywikiEscapedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"final url is %@",url);
    
    //    NSString *url = @"http://zh.wiktionary.org/w/api.php?action=query&prop=iwlinks&format=json&iwlimit=30&iwprefix=en&titles=%E6%82%A8%E5%A5%BD";
    //    NSString *url = [[NSString alloc] initWithFormat:@"%@/w/api.php?action=query&prop=langlinks&lllang=%@&titles=%@&format=json", apiUrl,[UserDefaluts objectForKey:@"targetLanguageCode"], name];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlywikiEscapedURL]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"json: %@",json_string);
    
    NSString *baseString = SharedAppDelegate.isNativeSrchLang ? [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode]:[[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
    if ([baseString isEqualToString:@"de"]) {
        json_string = [json_string stringByReplacingOccurrencesOfString:@"Special:Search/" withString:@""];
    }
    // parse the JSON response into an object
    // Here we're using NSArray since we're parsing an array of JSON status objects
    NSDictionary *wikipediaResponseObject = [parser objectWithString:json_string];
    
    NSArray *htmlTemp = [[[wikipediaResponseObject objectForKey:@"query"] objectForKey:@"pages"] allValues];
    
    if(![[htmlTemp objectAtIndex:0] objectForKey:@"iwlinks"]) {
        return nil;
    }
    
    NSMutableArray *htmlSrc = [[htmlTemp objectAtIndex:0] objectForKey:@"iwlinks"] ;
    
    return htmlSrc;
}


- (NSString *) getWikipediaHTMLPage:(NSString *)name {
    // Fetch wikipedia article
    NSString *htmlSrc = [self getWikipediaArticle:name];
    
    if([htmlSrc isEqualToString:@""])
        return htmlSrc;
    
    // NSString *formatedHtmlSrc = [htmlSrc stringByReplacingOccurrencesOfString:@"h3" withString:@"h2"];
    
    NSString *wikiString = [NSString stringWithFormat:@"%@/wiki/", apiUrl];
    NSString *ahrefWikiString = [NSString stringWithFormat:@"<a href=\"%@/wiki\"", apiUrl];
    NSString *ahrefWikiStringReplacement = [NSString stringWithFormat:@"<a target=\"blank\" href=\"%@/wiki\"", apiUrl];
    
    NSString *formatedHtmlSrc = [htmlSrc stringByReplacingOccurrencesOfString:@"/wiki/" withString:wikiString];
    formatedHtmlSrc = [formatedHtmlSrc stringByReplacingOccurrencesOfString:ahrefWikiString withString:ahrefWikiStringReplacement];
    
    formatedHtmlSrc = [formatedHtmlSrc stringByReplacingOccurrencesOfString:@"//upload.wikimedia.org" withString:@"http://upload.wikimedia.org"];
    formatedHtmlSrc = [formatedHtmlSrc stringByReplacingOccurrencesOfString:@"class=\"editsection\"" withString:@"style=\"visibility: hidden\""];
    
    
    // Append html and body tags, Add some style
    formatedHtmlSrc = [NSString stringWithFormat:@"<body style=\"font-size: 13px; font-family: Helvetica, Verdana\">%@<br/><br/><br/>The article above is based on this article of the free encyclopedia Wikipedia and it is licensed under „Creative Commons Attribution/Share Alike“. Here you find versions/authors.</body>", formatedHtmlSrc];
    
    return formatedHtmlSrc;
}

- (NSString *) getUrlOfMainImage:(NSString *)name {
    
    // Fetch wikipedia article
    NSString *htmlSrc = [self getWikipediaArticle:name];
    
    // Otherwise images have an incorrect url
    NSString *formatedHtmlSrc = [htmlSrc stringByReplacingOccurrencesOfString:@"//upload.wikimedia.org" withString:@"http://upload.wikimedia.org"];
    
    if([htmlSrc isEqualToString:@""])
        return htmlSrc;
    
    NSArray *splitonce = [formatedHtmlSrc componentsSeparatedByString:@"src=\""];

    NSString *finalSplitString = [[NSString alloc]  initWithString:[splitonce objectAtIndex:1]];
    NSArray *finalSplit = [finalSplitString  componentsSeparatedByString:@"\""];

    NSString *imageURL = [[NSString alloc]  initWithString:[finalSplit objectAtIndex:0]];
    imageURL = [imageURL stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]];

    int i = 1;
    
    while([self isOnBlackList:imageURL]) { 
        // Get the next image tag
        finalSplitString = [[NSString alloc]  initWithString:[splitonce objectAtIndex:i]];
        
        finalSplit = [finalSplitString  componentsSeparatedByString:@"\""];
        
        imageURL = [[NSString alloc]  initWithString:[finalSplit objectAtIndex:0]];
        imageURL = [imageURL stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]];
        
        i++;
    }
    
    return imageURL;
}

- (BOOL) isOnBlackList:(NSString *)imageURL {
    // Check if its not the correct image (Sometimes there are articles where the first image is an icon..)
    for(NSString *img in imageBlackList) {
        if([img isEqualToString:imageURL]) {
            return true;
        }
    }
    
    return false;
}

@end
