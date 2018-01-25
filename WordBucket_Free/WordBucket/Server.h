

#import "Defines.h"
#import <Foundation/Foundation.h>

@protocol WebserviceDelegate
- (void)webserviceCallFinished:(NSMutableArray*)responseData;
@end
@interface Server : NSObject <NSXMLParserDelegate>{
    id<WebserviceDelegate> delegate;
    NSMutableDictionary *dataDict;
    NSMutableData *responseData;
    NSMutableArray		*arrData;
}
@property(nonatomic,retain)NSMutableData * responseData;
@property(nonatomic,retain)id<WebserviceDelegate> delegate;
-(NSMutableDictionary*) getResults;
-(void)callService:(NSString*)urlString;
-(void)callPostService:(NSString*)urlString:(NSString*)url;
@end
