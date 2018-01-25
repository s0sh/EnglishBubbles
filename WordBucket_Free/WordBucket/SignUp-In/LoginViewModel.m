//
//  LoginViewModel.m
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import "LoginViewModel.h"
#import "SynchronizationModel.h"
@implementation LoginViewModel

-(instancetype)init
{

    self = [super init];
    if(self){
    
        [self initialize];
    
    }

    return self;
}
-(id)initialize
{
    self.joinService = [WBDummyJoinInService new];
    self.executeJoin =
    [[RACCommand alloc] initWithEnabled:[self observeNameField]
                            signalBlock:^RACSignal *(id input) {
                                return  [self executeJoinSignal];
                            }];
    
    
    return self;
    
}
-(RACSignal *)observeNameField
{

    RACSignal *validSignal = [[RACObserve(self, nameStr) map:^id(NSString *text) {
        
        return @(text.length > 3);
        
    }]distinctUntilChanged];
    
    [validSignal subscribeNext:^(id x) {
        NSLog(@"Name text is valid %@", x);
    }];
    
    return validSignal;
}
-(RACSignal *)executeJoinSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
    {
        [self.joinService signInWithUsername:self.nameStr password:self.passwordStr andEmail:self.emailStr
         complete:^(NSDictionary *success) {
             if([[NSString stringWithFormat:@"%@",success[@"error"] ] isEqualToString:@"0"])
             {
                 NSLog(@"Returned by server [FAKE] \n%@",success);
                 [[SynchronizationModel currentObject] parseAndUseData:success];
             }
             self.successDict = [NSDictionary dictionaryWithDictionary:success];
             [subscriber sendNext:success];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}// updates the enabled state and style of the text fields based on whether the current username
// and password combo is valid

@end
