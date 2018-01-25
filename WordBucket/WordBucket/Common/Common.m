//
//  Common.m
//  WeddingVenue
//
//  Created by Mehak Bhutani on 11/23/12.
//  Copyright (c) 2012 TechAhead. All rights reserved.
//

#import "Common.h"

#import "Reachability.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation Common


@synthesize delegate,pickerDelegate,control,imgDelegate;
static Common *objCommon = nil;
+(Common *) sharedInstance
{
    if(!objCommon)
        objCommon = [[Common alloc] init];
    
    return objCommon;
    
}

-(NSString *) getDatabasePath {
	
	NSString *docsDir;
	NSArray *dirPaths;
	// Get the documents directory
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	docsDir = [dirPaths objectAtIndex:0];
	
	// Build the path to the database file
	return docsDir;//[docsDir stringByAppendingPathComponent: @"WordBucket.sqlite"];
	
}
-(NSString *) checkNull:(NSString *) stringToCheck {
    
    if([stringToCheck isKindOfClass:[NSNull class]])
        stringToCheck = @"";
    return stringToCheck;
}
#pragma Tweet button
- (void)sendEasyTweet:(id)sender text:(NSString *)text withUrl:(NSURL*)urlStr{
    
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    //text = [text stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    [tweetViewController setInitialText:text];
    //[tweetViewController setInitialText:@"Acabo de encontrar la palabra \"bed\" en @Wordbucket. Una magnifica aplicación para encontrar y aprender palabras nuevas en inglés."];
    if(urlStr)
        [tweetViewController addURL:urlStr];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        
        NSString *output;
        
        switch (result) {
                
            case TWTweetComposeViewControllerResultCancelled:
                
                // The cancel button was tapped.
                
                output = @"Tweet cancelled.";
                
                break;
                
            case TWTweetComposeViewControllerResultDone:
                
                // The tweet was sent.
                
                output = @"Tweet done.";
                
                break;
                
            default:
                
                break;
                
        }
        
        [sender dismissModalViewControllerAnimated:YES];
        
    }];
    
    [sender presentModalViewController:tweetViewController animated:YES];
    
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet:(id)sender emailBody:(NSString *)body withSubject:(NSString*)subject
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    [picker setSubject:subject];
	[picker setMessageBody:body isHTML:YES];
	[sender presentModalViewController:picker animated:YES];
	
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			
			break;
		case MFMailComposeResultSaved:
			
			break;
		case MFMailComposeResultSent:
			
			break;
		case MFMailComposeResultFailed:
			
			break;
		default:
			
			break;
			
	}
	[controller dismissModalViewControllerAnimated:YES];
}

#pragma Message Composer

- (void)sendSMS:(id)sender message:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [sender presentModalViewController:controller animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else 
        NSLog(@"Message failed")  ;
                
}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice:(id)sender emailBody:(NSString *)body
{
    NSString *email = @"";
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)showMailPicker:(id)sender subject:(NSString *)subject emailBody:(NSString *)body
{
	// This sample can run on devices running iPhone OS 2.0 or later
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
	// So, we must verify the existence of the above class and provide a workaround for devices running
	// earlier versions of the iPhone OS.
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet:sender emailBody:body withSubject:subject];
		}
		else
		{
			[self launchMailAppOnDevice:sender emailBody:body];
		}
	}
	else
	{
		[self launchMailAppOnDevice:sender  emailBody:body];
	}
}

//pop up UIAction sheet
-(void) popUpActionSheet:(id)sender buttonTitle:(NSArray *)arrButtonTitle desctructiveButtonIndex:(NSInteger)index
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for(int i=0;i<[arrButtonTitle count];i++)
    {
        [action addButtonWithTitle:[arrButtonTitle objectAtIndex:i]];
    }
    
    action.destructiveButtonIndex = index;
    action.delegate = self;
    [action removeFromSuperview];
    [action showInView:sender];
}

#pragma UIActionSheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [delegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
}


//draw UIpicker view
- (UIToolbar *) returnToolbar:(NSInteger) tag frame:(CGRect)frame {
	
    tagValue = tag;
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    CGRect pickFrame = frame;
    if([UserDefaluts boolForKey:@"iPhone5"])
     pickFrame.origin.y = 290;
    else
     pickFrame.origin.y = 200;
    
    pickerToolbar.frame = pickFrame;
	pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
	[pickerToolbar sizeToFit];
	
	//next previous control
    control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
                                                         NSLocalizedString(@"Previous",@"Previous form field"),
                                                         NSLocalizedString(@"Next",@"Next form field"),
                                                         nil]];
	control.segmentedControlStyle = UISegmentedControlStyleBar;
	control.tintColor = [UIColor darkGrayColor];
	control.momentary = YES;
	[control addTarget:self action:@selector(nextPreviousTool:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:control];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePickerTool:)];
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
	NSArray *items = [[NSArray alloc] initWithObjects:flex, barButtonItem, nil];
	
	[pickerToolbar setItems:items animated:YES];
    
    return pickerToolbar;
	
}
-(void) nextPreviousTool:(id)sender
{
    switch([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            [[self pickerDelegate] previousField:tagValue];
            break;
        case 1:
            [[self pickerDelegate] nextField:tagValue];
            break;
    }
    
}
-(void) closePickerTool:(id)sender
{
    [[self pickerDelegate] closePicker:tagValue];
}
- (void)cancelPickerTool:(id)sender
{
    [[self pickerDelegate] cancelPicker:tagValue];
}

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma ActivityIndicator
-(void)showActivityIndicator:(UIViewController*)controller{
    
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];//d
    activityView = nil;
	if (activityView ==nil)
	{
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame=CGRectMake(0, 0,100, 80);
        activityView.layer.cornerRadius=10.0f;
        [activityView.layer setMasksToBounds:YES];
        activityView.alpha=0.9f;
        activityView.backgroundColor=[UIColor blackColor];
	}
	[activityView setCenter:CGPointMake(controller.view.bounds.size.width/2.0, 180)];
	[controller.view addSubview:activityView];
	[activityView startAnimating];
}

-(void)stopActivityIndicator:(UIViewController*)controller{
    
    // [[UIApplication sharedApplication] endIgnoringInteractionEvents];//d
	if (activityView ==nil)
	{
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	}
	[activityView stopAnimating];
	[activityView removeFromSuperview];
}

-(NSInteger) getWordCount:(NSString *)bucketColor
{
    NSMutableArray *arrWordCount = nil;
    if(![bucketColor isEqualToString:@""])
    {
        arrWordCount = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = '%@' and action !=''",bucketColor] withField:@"COUNT(targetWord)"];
        if([arrWordCount count]>0)
            return [[arrWordCount objectAtIndex:0] intValue];
    }
    else
    {
        arrWordCount = [[DBHelper sharedDbInstance] fetchRecordFromDB:@"tbl_Dictionary" withField:@"COUNT(targetWord)"];
        if([arrWordCount count]>0)
            return [[arrWordCount objectAtIndex:0] intValue];
    }
    return 0;
}
-(NSInteger) getBucketTestWords:(NSString *)bucketColor action:(NSString *)action
{
    NSMutableArray *arrWordCount = nil;
   
    arrWordCount = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor = '%@' AND action = '%@'",bucketColor,action] withField:@"COUNT(DISTINCT targetWord)"];
   
    if([arrWordCount count]>0)
        return [[arrWordCount objectAtIndex:0] intValue];
    return 0;
}

-(NSInteger)getAllWordExceptGreen
{
    NSMutableArray *arrWordCount = nil;
    
    arrWordCount = [[DBHelper sharedDbInstance] fetchRecordFromDB:[NSString stringWithFormat:@"tbl_Dictionary WHERE bucketColor != 'Green' AND action != ''"] withField:@"COUNT(DISTINCT targetWord)"];
    
    if([arrWordCount count]>0)
        return [[arrWordCount objectAtIndex:0] intValue];
    return 0;
}

- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    
//    action();
//    
//    return;
    [FBSession openActiveSessionWithAllowLoginUI:YES];
    if(FBSession.activeSession.isOpen)
    {
        NSArray *perms =FBSession.activeSession.permissions;
        
        if ([perms indexOfObject:@"publish_actions"] == NSNotFound) {
            // if we don't already have the permission, then we request it now
            
            NSLog(@"Permission not found ask for");
            perms = [NSArray arrayWithObject:@"publish_actions"];
            
            FBSession *a = FBSession.activeSession;
            [a reauthorizeWithPublishPermissions:perms                                       defaultAudience:FBSessionDefaultAudienceFriends
                               completionHandler:^(FBSession *session, NSError *error) {
                                   if (!error) {
                                       action();
                                   }
                                   //For this example, ignore errors (such as if user cancels).
                               }];
        } else {
            action();
        }

    }
    else
    {
        
       // [SharedAppDelegate openSessionWithAllowLoginUI:YES];
    }
        
}


+ (void)showAlert:(NSString *)message result:(id)result error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = nil;
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        //alertMsg = [NSLocalizedString(@"Successfully posted '%@'.\nPost ID: %@", nil),
    //message, [resultDict valueForKey:@"id"]];
        
        alertMsg = [NSString stringWithFormat:NSLocalizedString(@"Successfully posted '%@'.\nPost ID: %@", nil),message,[resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void) facebookGraphAPI
{
   
    [FBRequestConnection startWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"picture" forKey:@"fields"] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        {            
            NSLog(@"fbprofile_pic%@",[result valueForKey:@"picture"] );
//            if ([[result valueForKey:@"picture"] isKindOfClass:[NSData class]])
//            {
            NSLog(@"%@",[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]);
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]]];
                UIImage *profilePic = [[UIImage alloc] initWithData:data] ;
                            NSLog(@"mehak %@",profilePic);
//                UIImage* profilePic = [[UIImage alloc] initWithData: [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]];
                [self savePictureToLibrary:profilePic];
//            }
            
        }
    }];
    
    
}


+(void)checkSessionAndStartIfNeeded:(void(^)(BOOL success))block
{
    
     //NSArray *permissions =[NSArray arrayWithObjects:@"publish_actions",nil];
    
    if (FBSession.activeSession.isOpen) {
        // login is integrated with the send button -- so if open, we send
        NSLog(@"Session already Open");
        //[FacebookHandler getPersonalInfo];
        block(YES);
    } else {
        
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceOnlyMe
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (!error && status == FBSessionStateOpen) {
                                                 //[self publishStory];
                                                 
                                                 block(YES);
                                             }else{
                                                 NSLog(@"error");
                                                 block(NO);
                                             }
                                         }];
        
        
    }
    
}


-(void)postONFacebook:(NSString*)messageStr withUrl:(NSString*)urlStr
{

        NSMutableDictionary *postParams =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         urlStr, @"link",messageStr, @"description",nil];
        
        [FBRequestConnection startWithGraphPath:@"me/feed" parameters:postParams HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  
                                  NSLog(@"Post Result = %@",result);
                                  
                                  if (error) {
                                      NSLog(@"Failed to share post");
                                      [Common showAlert:@"" result:result error:error];
                                  } else {
                                      NSLog(@"Success to share post");
                                      [Common showAlert:@"" result:result error:error];
                                      
                                  }
                                  
                              }];
    
    
}

- (void)postStatusUpdateClick:(UIViewController *)viewController message:(NSString *) message withUrl:(NSURL *)urlStr {
    
    
         /*[self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startForPostStatusUpdate:message
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            
                                            [self showAlert:message result:result error:error];
                                            
                                        }];
            
        }];*/
    
    
    // if it is available to us, we will post using the native dialog
//    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:viewController
//                                                                    initialText:message
//                                                                          image:nil
//                                                                            url:urlStr
//                                                                        handler:nil];
    
    
    
    /*
    
    BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:viewController initialText:message image:nil url:urlStr handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
        
        NSLog(@"error is %@  %d",[error localizedDescription],result);
        
        
    }];
    
    if (!displayedNativeDialog) {
        
        [Common checkSessionAndStartIfNeeded:^(BOOL success) {
            
            [self postONFacebook:message withUrl:[urlStr absoluteString]];
        }];
            
    }*/
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        // code here
    
    
    SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init];
    //if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    //{
         //initiate the Social Controller
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [mySLComposerSheet setInitialText:message];
        [mySLComposerSheet addURL:urlStr];
        [viewController presentViewController:mySLComposerSheet animated:YES completion:nil];
    //}
    
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } 
    }];
        
    } else {
        
        [Common checkSessionAndStartIfNeeded:^(BOOL success) {
            
            [self postONFacebook:message withUrl:[urlStr absoluteString]];
        }];
    }
}
-(NSMutableArray *) swapArrayValues:(NSMutableArray *)array
{
    NSUInteger count = [array count];
    if (count == 3) {
        [array addObject:@"None"];
    }
    for (NSUInteger i = 0; i < [array count]; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        if(nElements>0)
        {
            NSInteger n = (arc4random() % nElements) + i;
            [array exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
    }
    return array;
}

-(NSString *) getBucketColor:(NSString *)strColor
{
    NSString *bucketColor = @"";
    if([[strColor capitalizedString] isEqualToString:@"White"])
        bucketColor = @"Grey";
    else
        bucketColor = strColor;
    
    
    return [bucketColor capitalizedString];
}
//format date
-(NSString *) stringDateFromString:(NSString *)stringDate
{
	NSString *strDate1=[stringDate substringWithRange:NSMakeRange(0, 19)];
	NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
	[dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dateSelected = [dateForm dateFromString:strDate1];
    dateForm = nil;
	
	dateForm = [[NSDateFormatter alloc] init];
	[dateForm setDateFormat:@"dd/MM"];
	NSString *date = [dateForm stringFromDate:dateSelected];
	dateForm = nil;
	return date;
}

-(NSString *) dateStringForDate:(NSDate *)date{
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init] ;
	[dateFormatter setDateFormat:@"dd/MM"];
	//[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	return [dateFormatter stringFromDate:date];
	
}



-(NSDate *) dateFormDateString:(NSString *)str format:(NSString *)format{
	
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init] ;
	[dateFormatter setDateFormat:format];
    // [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //	NSLog(@"%@",[dateFormatter dateFromString:str]);
	return [dateFormatter dateFromString:str];
}
//difference between two dates
-(NSInteger) getDateDifference:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    CGFloat hours = (CGFloat)interval / 3600.0;             // integer division to get the hours part
    //int minutes = (interval - (hours*3600)) / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
    CGFloat days = ceilf(hours/24.0);
    return days;
    
}
-(UIImage *) getImageWithName:(NSString *)imageName
{
	NSString  *pngPath = [[self getDatabasePath] stringByAppendingPathComponent:imageName];
    if([[NSFileManager defaultManager] fileExistsAtPath:pngPath])
        return [UIImage imageWithContentsOfFile:pngPath];
    return nil;
}
-(BOOL) checkInternetConnection
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        return NO;
	}
    return YES;
}

-(void)savePictureToLibrary:(UIImage *)image{
    
    UIImage *img = image;                    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.imgDelegate saveImage];
}                    
                    
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image saving %@",[error description]);
}

#pragma Rotate UIImage by some degree
-(UIImageView *) rotateImage :(UIImageView *) imageView angle:(CGFloat) angle
{
//    CGAffineTransform transform;
//    transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformMakeTranslation(imageView.image.size.width, imageView.image.size.height);
//    transform = CGAffineTransformRotate(transform, (M_PI / 2));
//    imageView.transform = transform;
    CGAffineTransform transform = imageView.transform;
    // Rotate the view 45 degrees (the actual function takes radians)
    transform = CGAffineTransformRotate(transform, -(M_PI / 18));
    imageView.transform = transform;
    return imageView;
}
-(NSString *) URLEncodeString:(NSString *) str
{
    
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
-(void) playSound:(id)sender fileName:(NSString *)fileName
{
    // For future purpose
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}



#pragma mark ------------ Class Method start here ------------------

+ (NSInteger)dayStringForDate:(NSDate *)date{
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init] ;
	[dateFormatter setDateFormat:@"dd"];
	//[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	return [[dateFormatter stringFromDate:date] integerValue];
	
}


+ (NSString*)getStringValueSeperatedByCommaWithArray:(NSMutableArray*)productArray
{
    NSMutableString *productString = [[NSMutableString alloc] init];
    
    for (int k = 0; k < [productArray count]; k++) {
        
        NSMutableString *aStr = [NSMutableString stringWithFormat:@"%@,",[productArray objectAtIndex:k]];
        [productString appendString:aStr];
        
    }
    [productString replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(productString.length-1, 1)];
    NSLog(@"product string is %@",productString);
    return productString;
}

+ (NSString*)getCombineStringFromArray:(NSMutableArray*)productArray withKey:(NSString*)key
{
    NSMutableString *productString = [[NSMutableString alloc] init];
    
    for (int k = 0; k < [productArray count]; k++) {
        
        NSMutableString *aStr = [NSMutableString stringWithFormat:@"%@,",[[productArray objectAtIndex:k] objectForKey:key]];
        [productString appendString:aStr];
        
    }
    [productString replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(productString.length-1, 1)];
    NSLog(@"product string is %@",productString);
    return productString;
}


+ (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.4];
    NSInteger yValue = SharedAppDelegate.isPhone5 ? 568 : 480;
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, yValue, view.frame.size.width,
                                      view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y,
                                      view.frame.size.width, yValue)];
        }
    }
    
    //[UIView commitAnimations];
}

+ (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    NSInteger yValue = SharedAppDelegate.isPhone5 ? 511 : 423;
    //NSInteger yValue = SharedAppDelegate.isPhone5 ? 519 : 431;
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, yValue, view.frame.size.width,
                                      view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y,
                                      view.frame.size.width, yValue+8)];
        }
    }
    
    NSLog(@"tab bar selected index is  +++++ %d",tabbarcontroller.selectedIndex);
    
}


#pragma mark label
+ (UILabel*)createNewLabelWithTag:(NSInteger)aTag WithFrame:(CGRect)lblframe text:(NSString*)aText noOfLines:(NSInteger)noOfLine color:(UIColor*)color withFont:(UIFont*)font
{
	UILabel *aLabel = [[UILabel alloc] init];
	aLabel.frame = lblframe;
	aLabel.text = aText;
	aLabel.tag = aTag;
    aLabel.font = font;
	aLabel.textColor = color;
	aLabel.backgroundColor = [UIColor clearColor];
	aLabel.adjustsFontSizeToFitWidth = YES;
	aLabel.numberOfLines = noOfLine;
	aLabel.textAlignment = UITextAlignmentLeft;
	return aLabel;
}


+ (NSString*)getTargetLanguage
{
    NSString *targetString = @"";
    
    if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"en"]) {
        targetString = @"English";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"ru"]) {
        targetString = @"Russian";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"it"]) {
        targetString = @"Italian";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"pt"]) {
        targetString = @"Portuguese";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"ko"]) {
        targetString = @"Korean";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"de"]) {
        targetString = @"German";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"hi"]) {
        targetString = @"Hindi";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"zh"]) {
        targetString = @"Chinese";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"es"]) {
        targetString = @"Spanish";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"ar"]) {
        targetString = @"Arabic";
    } else if ([[UserDefaluts objectForKey:kTargetLangCode] isEqualToString:@"ja"]) {
        targetString = @"Japanese";
    } else {
        targetString = @"French";
    }
    
    return targetString;
    
}

+ (NSString*)getLanguageWithCode:(NSString*)codeString
{
    NSString *targetString = @"";
    
    if ([codeString isEqualToString:@"en"]) {
        targetString = @"English";
    } else if ([codeString isEqualToString:@"ru"]) {
        targetString = @"Russian";
    } else if ([codeString isEqualToString:@"it"]) {
        targetString = @"Italian";
    } else if ([codeString isEqualToString:@"pt"]) {
        targetString = @"Portuguese";
    } else if ([codeString isEqualToString:@"ko"]) {
        targetString = @"Korean";
    } else if ([codeString isEqualToString:@"de"]) {
        targetString = @"German";
    } else if ([codeString isEqualToString:@"hi"]) {
        targetString = @"Hindi";
    } else if ([codeString isEqualToString:@"zh"]) {
        targetString = @"Chinese";
    } else if ([codeString isEqualToString:@"es"]) {
        targetString = @"Spanish";
    } else if ([codeString isEqualToString:@"it"]) {
        targetString = @"Italian";
    } else if ([codeString isEqualToString:@"ja"]) {
        targetString = @"Japanese";
    } else if ([codeString isEqualToString:@"ko"]) {
        targetString = @"Korean";
    } else if ([codeString isEqualToString:@"pt"]) {
        targetString = @"Portuguese";
    } else if ([codeString isEqualToString:@"ru"]) {
        targetString = @"Russian";
    } else if ([codeString isEqualToString:@"ar"]) {
        targetString = @"Arabic";
    } else {
        targetString = @"French";
    }
    
    return targetString;
    
}



+ (NSString*)audioLanguagesWithCode:(NSString*)languageCode
{
    NSString *speechLanguage = @"";
    
    if ([languageCode isEqualToString:@"en"]) {
        speechLanguage = @"usenglishfemale";
    } else if ([languageCode isEqualToString:@"ru"]) {
        speechLanguage = @"rurussianfemale";
    } else if ([languageCode isEqualToString:@"it"]) {
        speechLanguage = @"euritalianfemale";
    } else if ([languageCode isEqualToString:@"pt"]) {
        speechLanguage = @"eurportuguesefemale";
    } else if ([languageCode isEqualToString:@"ko"]) {
        speechLanguage = @"krkoreanfemale";
    } else if ([languageCode isEqualToString:@"de"]) {
        speechLanguage = @"eurgermanfemale";
    } else if ([languageCode isEqualToString:@"hi"]) {
        speechLanguage = @"usenglishfemale";
    } else if ([languageCode isEqualToString:@"zh"]) {
        speechLanguage = @"chchinesefemale";
    } else if ([languageCode isEqualToString:@"es"]) {
        speechLanguage = @"eurspanishfemale";
    } else {
        speechLanguage = @"eurfrenchfemale";
    }
    
    return speechLanguage;
}

+ (NSString*)setLanguageOniCloudFile
{
    return [NSString stringWithFormat:@"native=%@##target=%@",[UserDefaluts objectForKey:kNativeLangCode],[UserDefaluts objectForKey:kTargetLangCode]];
}



#pragma mark - Use it when pickup an image from imagepicker
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image
{
	int kMaxResolution = 100;
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution)
	 {
	 CGFloat ratio = width/height;
	 if (ratio > 1)
	 {
	 bounds.size.width = kMaxResolution;
	 bounds.size.height = bounds.size.width / ratio;
	 }
	 else
	 {
	 bounds.size.height = kMaxResolution;
	 bounds.size.width = bounds.size.height * ratio;
	 }
	 } 
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient)
	{
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			break;
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
	{
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else
	{
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
	
}

#pragma mark - UIAlertView
////----- show a alert massage
+ (void) showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate
      cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
	[alert show];
}

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
	[alert show];
}

+ (void)playCorrectSound
{
    if ([[UserDefaluts objectForKey:kisSoundOn] boolValue]  || (![UserDefaluts objectForKey:kisSoundOn]))
    {
        SystemSoundID bell;
        AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CORRECT.wav" ofType:nil]], &bell);
        AudioServicesPlaySystemSound (bell);
    }
}

+ (void)playIncorrectSound
{
    if ([[UserDefaluts objectForKey:kisSoundOn] boolValue]  || (![UserDefaluts objectForKey:kisSoundOn]))
    {
        SystemSoundID bell;
        AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"INCORRECT.wav" ofType:nil]], &bell);
        AudioServicesPlaySystemSound (bell);
    }
}

+ (NSInteger)differencefromtodayDay:(NSDate*)startDate
{
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:startDate];
    
    NSInteger numberOfDays = secondsBetween / 86400;
    return numberOfDays;

}

+(NSDate *)dateFromString:(NSString*)aStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //[dateFormatter setLocale:[NSLocale currentLocale]];
 	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    NSDate *aDate = [dateFormatter dateFromString:aStr];
    NSLog(@"Date in NSDate = %@",aDate);
	return aDate;
}

//install preinstalled words
-(void)reinsertAllWord
{
    NSString *nativeLang = [Common getLanguageWithCode:[UserDefaluts valueForKey:kNativeLangCode]];
    NSString *targetLang = [Common getLanguageWithCode:[UserDefaluts valueForKey:kTargetLangCode]];
    NSLog(@"%@ %@ %@",[UserDefaluts objectForKey:kNativeLangCode],[UserDefaluts objectForKey:kTargetLangCode],[UserDefaluts objectForKey:kUserLevel]);
    NSString *tableName = nil;
    if ([[UserDefaluts objectForKey:kUserLevel] isEqualToString:@"Advanced"]) {
        tableName = @"tbl_Words_Advanced";
    } else if ([[UserDefaluts objectForKey:kUserLevel] isEqualToString:@"Intermediate"]) {
        tableName = @"tbl_Words_Intermediate";
    } else {
        tableName = @"tbl_Words";
    }
    NSDate *currentDate = [NSDate date];
    
    NSMutableArray *arrWords = [[DBHelper sharedDbInstance] fetchRecordFromDB:tableName withField:[NSString stringWithFormat:@"%@,%@",nativeLang,targetLang]];
    
    NSString *multipleRowData = @"insert into tbl_Dictionary (targetWord,nativeWord,bucketColor,nativeLanguage,targetLanguage,action,userLevel,sense,POS,dateOfTest) ";
    NSString *strUnion = @"";
    for(int i=0;i<[arrWords count];i++)
    {
        
        NSArray *arrLan = [[arrWords objectAtIndex:i] componentsSeparatedByString:@"/|"];
        //if(i>=0 && i<15)
        strUnion = [strUnion stringByAppendingString:[NSString stringWithFormat:@"select \"%@\" as targetWord,\"%@\" as nativeWord, '%@' as bucketColor, '%@' as nativeLanguage, '%@' as targetLanguage, '%@' as action, '%@' as userLevel, '%@' as sense, '%@' as POS, '%@' as dateOfTest union ",[arrLan objectAtIndex:1],[arrLan objectAtIndex:0],@"White",[UserDefaluts valueForKey:@"nativeLanguageCode"],[UserDefaluts valueForKey:kTargetLangCode],@"Saved",[UserDefaluts objectForKey:kUserLevel],@"",@"",currentDate]];
    }
    
    if([strUnion length]>0)
        multipleRowData = [multipleRowData stringByAppendingString:[strUnion substringToIndex:[strUnion length]-6]];
    
    [[DBHelper sharedDbInstance] insertMultipleRows:multipleRowData];
    
}

+ (UIFont*)AdjustLabelFont:(UILabel*)label
{
    CGFloat wd = label.frame.size.width;
    CGFloat ht = label.frame.size.height;
    NSString *string = label.text;
    label.numberOfLines = 0;
    CGSize constraint = CGSizeMake(wd, 2000.0f);
    UIFont *font = label.font;
    NSInteger finalFont = label.font.pointSize;
    for (int k = finalFont; k >1; k--) {
        CGSize size = [string sizeWithFont:[font fontWithSize:k]
                         constrainedToSize:constraint
                             lineBreakMode:UILineBreakModeWordWrap];
        
        if (size.height <= ht) {
            finalFont = k;
            break;
        }
        
    }
    
    return [font fontWithSize:finalFont];
}



@end
