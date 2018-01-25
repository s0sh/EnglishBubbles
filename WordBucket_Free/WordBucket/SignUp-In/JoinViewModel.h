//
//  JoinViewModel.h
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "WBDummyJoinInService.h"
@interface JoinViewModel : NSObject
@property(nonatomic,retain)NSString *nameStr;
@property(nonatomic,retain)NSString *passwordStr;
@property(nonatomic,retain)NSString *emailStr;
@property(nonatomic,retain)__block NSDictionary *successDict;
@property(nonatomic,strong)WBDummyJoinInService *joinService;
@property (strong, nonatomic) RACCommand *executeJoin;
@end
