//
//  WBDummyJoinInService.m
//  WordBucket
//
//  Created by Roman Bigun on 4/11/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import "WBDummyJoinInService.h"

@implementation WBDummyJoinInService


#define kDummyDataInReturn1 [NSDictionary dictionaryWithObjectsAndKeys:@"кролик",kNativeWord,@"rabbit",kTargetWord,@"",@"image_url",@"",@"audio_url",@" small domesticated carnivorous mammal with soft fur, a short snout, and retractile claws",@"meaning",@"Domestic cats may breed much more frequently, as often as 3 times a year, as they are not typically limited by nutrition or climate.",@"example",@"",@"lexical_type",@"wiktionary",@"source",@"56e851470be444098ecbeac1",@"id",@"White",@"BucketColor",nil]
#define kDummyDataInReturn2 [NSDictionary dictionaryWithObjectsAndKeys:@"буйвол",kNativeWord,@"bull",kTargetWord,@"",@"image_url",@"",@"audio_url",@"an act of holding someone tightly in one's arms, typically to express affection.",@"meaning",@"there were hugs and tears as they were reunited",@"example",@"",@"lexical_type",@"wiktionary",@"source",@"56e851470be444098ecbeac0",@"id",@"Orange",@"BucketColor",nil]
#define kDummyDataInReturn3 [NSDictionary dictionaryWithObjectsAndKeys:@"красный",kNativeWord,@"red",kTargetWord,@"",@"image_url",@"",@"audio_url",@"a round, deep dish or basin used for food or liquid.",@"meaning",@"a mixing bowl",@"example",@"",@"lexical_type",@"wiktionary",@"source",@"56e851470be444098ecbeac2",@"id",@"Red",@"BucketColor",nil]
#define dataArray [NSArray arrayWithObjects:kDummyDataInReturn1,kDummyDataInReturn2,kDummyDataInReturn3,nil]

#define returningJson [NSDictionary dictionaryWithObjectsAndKeys:dataArray,@"data",@"1",@"success",@"0",@"error",nil]
#define returningJsonFailed [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success",@"403",@"error",nil]


/**
 *  Dummy request.
 *
 *  @param username      name
 *  @param password      password
 *  @param email         email
 *  @param completeBlock The data came from backend should be pushed throuught this block to subscribers
 */
- (void)signInWithUsername:(NSString *)username password:(NSString *)password andEmail:(NSString *)email complete:(RWSignInResponse)completeBlock {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        BOOL success = NO;
        [[NSUserDefaults standardUserDefaults] objectForKey:@"enterAction"];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"enterAction"] isEqualToString:@"1"])
        {
            completeBlock(returningJson);
            [[[UIAlertView alloc] initWithTitle:@"Registration" message:@"SUCCESS!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        
        }
        success = [username isEqualToString:@"test@test.com"] && [password isEqualToString:@"password"];
        
        [[[UIAlertView alloc] initWithTitle:@"SignIn" message:success?@"SUCCESS!":@"FAILED!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        if(success){
           completeBlock(returningJson);
            return;
        }
        completeBlock(returningJsonFailed);
        return;
        
    });
}
-(void)sendSynchRequest:(NSDictionary*)dataToSend complete:(RWSignInResponse)completeBlock{
   
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        
    
    });
    
    completeBlock(returningJson);

}
@end