//
//  LoginViewController.h
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
- (IBAction)joinWithFacebook:(id)sender;
- (IBAction)joinWithTwitter:(id)sender;

@end
