//
//  SynchronizationModel.h
//  WordBucket
//
//  Created by Roman Bigun on 4/12/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SynchronizationModel : NSObject

@property(nonatomic,retain)NSString *nativeWord;
@property(nonatomic,retain)NSString *targetWord;
@property(nonatomic,retain)NSString *nativeLanguage;
@property(nonatomic,retain)NSString *targetLanguage;
@property(nonatomic,retain)NSDictionary *paramsToSend;
@property(nonatomic,retain)__block NSMutableArray *currentModel;
@property(nonatomic,retain)__block NSMutableArray *arrWord;
@property BOOL canBeAdded;

+(SynchronizationModel*)currentObject;
-(void)parseAndUseData:(NSDictionary *)data;
-(void)makeAndStorePairWithNativeWord:(NSString *)native andTarget:(NSString*)target bucketColor:(NSString*)bColor;
-(void)prepareJsonWithNewWord:(NSDictionary*)word;

@end
