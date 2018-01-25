
#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>


@protocol FacebookDelegate
-(void) fbLogin;
@end
@interface FacebookViewC : UIViewController <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,UserInfoLoadDelegate>
{
	// Facebook
	IBOutlet FBLoginButton* _fbButton;
	Facebook* _facebook;
	NSArray* _permissions;
	BOOL emailBool;
	BOOL friendsBool;
	UserInfo *_userInfo;
	id loginDelegate;
	id<FacebookDelegate> fbDelegate;
}

@property (nonatomic, assign) 	id loginDelegate;
@property (nonatomic, retain) 	id<FacebookDelegate> fbDelegate;

-(void) facebookButtonClicked;
-(void) publish:(NSString *)str;
-(void) getUserInfo;
-(void) getFriends;
-(void) callLoginGo;
-(void) callLogOut;
- (void) login ;
@end
