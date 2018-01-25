//
//  LoginViewModel.m
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import "JoinViewModel.h"
#import "SynchronizationModel.h"
@implementation JoinViewModel


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
    [[RACCommand alloc] initWithEnabled:[self observeEmailField]
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
-(RACSignal *)observeEmailField
{
    
    RACSignal *validSignal = [[RACObserve(self, emailStr) map:^id(NSString *text) {
        
        return @(text.length>3);
        
    }]distinctUntilChanged];
    
    [validSignal subscribeNext:^(id x) {
        NSLog(@"Email text is valid %@", x);
    }];
    
    return validSignal;
    
    
}
- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}
- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}
-(RACSignal *)executeJoinSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
    {
        [self.joinService signInWithUsername:self.nameStr password:self.passwordStr andEmail:self.emailStr
         complete:^(NSDictionary *success) {
             if([[NSString stringWithFormat:@"%@",success[@"error"] ] isEqualToString:@"0"])
             {
                 NSLog(@"Returned by server [FAKE] \n%@",success);
                 self.successDict = [NSDictionary dictionaryWithDictionary:success];
                 [[SynchronizationModel currentObject] parseAndUseData:success];
             }
             [subscriber sendNext:success];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}// updates the enabled state and style of the text fields based on whether the current username
// and password combo is valid

@end
