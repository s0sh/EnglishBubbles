//
//  SynchronizationModel.m
//  WordBucket
//
//  Created by Roman Bigun on 4/12/16.
//  Copyright © 2016 Mehak Bhutani. All rights reserved.
//

#import "SynchronizationModel.h"
#import "DBHelper.h"
#import "SplashVC.h"
#define kSynchObjectKey @"SynchObjectKey"
#define RetriveObjectFromStore  [[NSUserDefaults standardUserDefaults] objectForKey:kSynchObjectKey]
#define Buckets [NSArray arrayWithObjects:@"White",@"Orange",@"Green",nil]
#define returningWord1 [NSDictionary dictionaryWithObjectsAndKeys:@"Orange",kBucketColor,@"дорога",kNativeWord,"road",kTargetWord,nil]
#define returningWord2 [NSDictionary dictionaryWithObjectsAndKeys:@"Red",kBucketColor,@"белый",kNativeWord,"white",kTargetWord,nil]

@implementation SynchronizationModel

@synthesize currentModel = _currentModel;
@synthesize arrWord = _arrWord;
-(id)init
{
    self = [super init];
    if(self)
    {
        _currentModel  = [[NSMutableArray alloc] init];
        _arrWord = [[NSMutableArray alloc] init];//words in buckets
        _currentModel = RetriveObjectFromStore;//synd data after login/register
        _canBeAdded = NO;
        
    }
    return self;
    
}

-(BOOL)checkWordInBucketWithColor:(NSString *)bucketColor andTestWord:(NSString*)testWord
{
    if(!_arrWord){
      _arrWord = [[NSMutableArray alloc] init];
    }
        
    _arrWord =[[DBHelper sharedDbInstance] getAllValuesFromDictionaryTable:[NSString stringWithFormat:@"select * from tbl_Dictionary WHERE (bucketColor = 'White' and action = 'Saved') OR (bucketColor = 'Red') ORDER BY RANDOM() LIMIT %d",1000]];
    for(int i=0;i<_arrWord.count;i++){
        if(![_arrWord[i][@"targetWord"] isEqualToString:testWord]){
            continue;
        }
        else{
        
            return YES;
        
        }
    }
    
    
    return NO;

}
+(SynchronizationModel*)currentObject
{

    static SynchronizationModel * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[SynchronizationModel alloc] init];
        
    });
    return _sharedInstance;

}
/**
 *  Main method for synch after login/register action. Uses when data returned from backend after Login/Register or whatever...
 *
 *  @param 'data' Objects(words) that comes from backend
 */
-(void)parseAndUseData:(NSDictionary *)data
{
    
    if(!_currentModel){
        _currentModel = [[NSMutableArray alloc] init];
    }
    _currentModel = [RetriveObjectFromStore mutableCopy];
    
    NSLog(@"Current objects in model\n%@",_currentModel);
    
    if([data isKindOfClass:[NSNull class]])
        return;
    
    NSArray *wordsArray = data[@"data"];
    
    for(int i=0;i<wordsArray.count;i++){
        
        _nativeWord = wordsArray[i][@"nativeWord"];
        _targetWord = wordsArray[i][@"targetWord"];
        
        if(_nativeWord.length>0 && _targetWord.length>0){
        
            [self makeAndStorePairWithNativeWord:_nativeWord andTarget:_targetWord bucketColor:wordsArray[i][@"BucketColor"]];//Store temporary
            
        }
    }
        
}
/**
 *  Store income data to local database and User Defaults
 *
 *  @param native nativeWord
 *  @param target targetWord
 *  @param bColor bucket color
 */
-(void)makeAndStorePairWithNativeWord:(NSString *)native andTarget:(NSString*)target bucketColor:(NSString*)bColor
{
    
    if(![self checkWordInBucketWithColor:bColor andTestWord:target]){
        
        [self addWord:[NSDictionary dictionaryWithObjectsAndKeys:native,kNativeWord,target,kTargetWord,bColor,@"BucketColor",nil]];
        NSInteger savedWord = [[UserDefaluts objectForKey:kTotalSavedWord] intValue];
        NSLog(@"words saved is %d",savedWord);
        
        if (savedWord < 25) {
            
            NSString *targetLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode];
            NSString *nativeLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
            
            
            NSString *alreadySaved = [[DBHelper sharedDbInstance] getSingleStringWithQuery:[NSString stringWithFormat:@"select COUNT(*) from tbl_Dictionary where targetWord = \"%@\" AND nativeword = \"%@\"",target,native]];
            if ([alreadySaved integerValue]>0) {
                
                /**
                 *  if already exists - Update that record
                 */
                
                [[DBHelper sharedDbInstance] updateRecordIntoTableNamed:
                [NSString stringWithFormat:@"tbl_Dictionary SET action = 'Saved' WHERE targetWord = \"%@\" AND nativeword = \"%@\"",target,native]];
                
            } else {
                
                /**
                 *  doesn't exist - Insert new record
                 */
                
                [[DBHelper sharedDbInstance] insertRecordIntoTableNamed:@"tbl_Dictionary" withField:@"targetWord, nativeWord, bucketColor, nativeLanguage, targetLanguage, action, userLevel, dateOfTest,sense,POS" fieldValue:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",target,native,bColor,nativeLanCode,targetLanCode,@"Saved",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLevel"],[NSDate date],@"",@""]];
            }
        }
        
        
    }
   

}
-(void)prepareJsonWithNewWord:(NSDictionary*)word
{
    if(word!=nil)
    {
        [self addWord:word];
    }
    
    NSString *targetLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kTargetLangCode];
    NSString *nativeLanCode = [[NSUserDefaults standardUserDefaults] objectForKey:kNativeLangCode];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_currentModel,@"words",targetLanCode,@"target_language",nativeLanCode,@"native_language",nil];
    NSLog(@"JSON prepared to send: %@",params);
   /*
    
    //TODO: Server Request with created 'params' object
    
    */
    
}
/**
 *  Check if the record is already exist in temporary storage
 *
 *  @param checkedWord test word
 *
 *  @return returns YES if exists. No need to synchronize
 */
-(BOOL)checkLocal:(NSString*)checkedWord
{
    BOOL exist = NO;
    for(int i=0;i<_currentModel.count;i++){
        if([_currentModel[i][@"nativeWord"] isEqualToString:checkedWord]){
            exist = YES;
        }
        
    }
    return exist;

}
/**
 *  adding word to temporary storage for further synchronization
 *
 *  @param word native and target words. Pair that is added
 */
-(void)addWord:(NSDictionary *)word
{
    if(!_currentModel){
        _currentModel = [[NSMutableArray alloc] init];
    }
    if(![self checkLocal:word[@"targetWord"]] && ![self checkLocal:word[@"nativeWord"]]){
    if(![word isKindOfClass:[NSNull class]] && word.count>0){
        [_currentModel addObject:word];
        [self storeCurrentObject];
        NSLog(@"Word stored: %@\nCurrent words\n%@",word,_currentModel);
     }
    }
    else{
    
        NSLog(@"Word currently existed");
    }
    

}
-(void)storeCurrentObject
{

    [[NSUserDefaults standardUserDefaults] setObject:_currentModel forKey:kSynchObjectKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
