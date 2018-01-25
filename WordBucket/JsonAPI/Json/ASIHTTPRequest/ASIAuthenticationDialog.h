//
//  ASIAuthenticationDialog.h
//  iPhone
//
//  Created by Ben Copsey on 21/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
// framework required-- libz 1.2.3dylib,CFNetwork.framework,systemconfigurationframework,
// and set the other linker flag to -licucore

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;

typedef enum _ASIAuthenticationType {
	ASIStandardAuthenticationType = 0,
    ASIProxyAuthenticationType = 1
} ASIAuthenticationType;
	
@interface ASIAuthenticationDialog : NSObject <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	ASIHTTPRequest *request;
	UIActionSheet *loginDialog;
	ASIAuthenticationType type;
}
+ (void)presentAuthenticationDialogForRequest:(ASIHTTPRequest *)request;
+ (void)presentProxyAuthenticationDialogForRequest:(ASIHTTPRequest *)request;

@property (retain) ASIHTTPRequest *request;
@property (retain) UIActionSheet *loginDialog;
@property (assign) ASIAuthenticationType type;
@end
