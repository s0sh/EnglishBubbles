////
//  Server.m

#import "Server.h"

//#import "JSON.h"

#import "Common.h"

@implementation Server
@synthesize responseData,delegate;

-(void)dealloc{

   // ReleaseObject(dataDict);
    [responseData release];
    [super dealloc];
}
- (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = [string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, string, NULL, nil, kCFStringEncodingUTF8);
    return newString;
}

-(void)callPostService:(NSString*)urlString:(NSString*)url {
    
    if([[Common sharedInstance] checkInternetConnection])
    {
        self.responseData = [NSMutableData data];
		NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
		[request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:[urlString dataUsingEncoding:NSUTF8StringEncoding]];
        //NSLog(@"SERVER REQUEST->> %@",urlString);
		[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Network Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}



// Web service request 
-(void)callService:(NSString*)urlString{
    
    urlString = [self encodeURL:urlString];
    if([[Common sharedInstance] checkInternetConnection])
    {
        self.responseData = [NSMutableData data];
       
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        // NSLog(@"SERVER REQUEST->> %@",urlString);
        [request setHTTPMethod:@"GET"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Network Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    

    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)respons
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    responseData = nil;
    //NSDictionary *googleResponse = [[NSString stringWithContentsOfURL: [NSURL URLWithString: @""] encoding: NSUTF8StringEncoding error: NULL] JSONValue];
}

#pragma mark -
#pragma mark Process connection
/*
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [connection release];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     responseString = [responseString stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
//    responseString = [responseString 
//                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"SERVER RESPONSE->> %@",dataDict);
    //NSLog(@"responseString->> %@",responseString);
    
    [delegate webserviceCallFinished];
   
    //[responseString release];
}
*/
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSString *string = [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding];
    NSDictionary *jsonArray = [string JSONFragmentValue];
    
    arrData = [[NSMutableArray alloc] init];
    
    [string release];
    
    if(jsonArray) {
        [arrData addObject:jsonArray];
    }
    
    [delegate webserviceCallFinished:arrData];
    [connection release];
    //[string release];
}


-(NSMutableDictionary*) getResults{
    return dataDict;
}
@end





