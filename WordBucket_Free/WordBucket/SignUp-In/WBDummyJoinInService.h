//
//  WBDummyJoinInService.h
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(NSDictionary*);

@interface WBDummyJoinInService : NSObject
{

}
- (void)signInWithUsername:(NSString *)username password:(NSString *)password andEmail:(NSString *)email complete:(RWSignInResponse)completeBlock;
-(void)sendSynchRequest:(NSDictionary*)dataToSend complete:(RWSignInResponse)completeBlock;
@end

