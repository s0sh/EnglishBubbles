

#import "FacebookViewC.h"

#import "FBConnect.h"
#import "FBRequest.h"

#define kAppId @"540867222608021"
@implementation FacebookViewC

@synthesize loginDelegate,fbDelegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_permissions =  [[NSArray arrayWithObjects: 
						  @"read_stream", @"offline_access",@"email",nil] retain];
		_facebook = [[Facebook alloc] init];
		_fbButton = [[FBLoginButton alloc] init];
		_fbButton.isLoggedIn   = NO;
		emailBool = NO;
		friendsBool = NO;
	}
    return self;
}


- (void) callLoginGo
{
	//[loginDelegate GO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    if (_fbButton.isLoggedIn) 
	{
		[self logout];
	} 

}

#pragma mark Facebook

- (void) login 
{
    
	[_facebook authorize:kAppId permissions:_permissions delegate:self];
   
}

- (void) logout 
{
	[_facebook logout:self]; 
}

-(void) facebookButtonClicked
{
	
	if (_fbButton.isLoggedIn) 
	{
		[self logout];
	} 
	else 
	{
		[self login];
	}
	
	
}

-(void) fbDidLogin 
{
	_fbButton.isLoggedIn         = YES;
	//[_fbButton updateImage];
	[self getUserInfo];
    
   
	
}
- (void)fbDidNotLogin:(BOOL)cancelled 
{
	//NSLog(@"did not login");
}

-(void) fbDidLogout 
{
	_fbButton.isLoggedIn         = NO;
	//[_fbButton updateImage];
}

#pragma mark Facebook delegate
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	//NSLog(@"received response");
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
}

- (void)request:(FBRequest*)request didLoad:(id)result 
{
	if ([result isKindOfClass:[NSArray class]])
	{
		result = [result objectAtIndex:0]; 
	}
	if ([result objectForKey:@"owner"]) 
	{
	} 
	else 
	{
		//[self.label setText:[result objectForKey:@"name"]];
		
		if(emailBool == YES)
		{
			
			
			[self getFriends];
			//[loginDelegate GO];

		}
		if(friendsBool == YES)
		{
			_userInfo = [[UserInfo alloc] initializeWithFacebook:_facebook andDelegate:self];
			[_userInfo requestAllInfo];
			
		}
	}
}

- (void)dialogDidComplete:(FBDialog*)dialog
{
	 [fbDelegate fbLogin];
}
- (void) getUserInfo
{
	emailBool = YES;
	friendsBool = NO;
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
}

-(void) getFriends
{
	friendsBool = YES;
	emailBool = NO;
	[_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

-(void) callLogOut{
    [self logout];	 
}

#pragma mark post to wall

- (void) publish:(NSString *)str
{
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"Word Bucket", @"name",
								@"Word Bucket", @"caption",
								str, @"description",
								 nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId, @"api_key",
//								   @"Share on Facebook",  @"user_message_prompt",
//								   attachmentStr, @"attachment",
								   nil];
	
	[_facebook dialog: @"stream.publish"
			andParams: params
		  andDelegate:self];
}


- (void)userInfoDidLoad{}
- (void)userInfoFailToLoad{}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[_fbButton release];
	[_facebook release];
	[_permissions release];
	[_userInfo release];
    [super dealloc];
}


@end
