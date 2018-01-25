

#import <Foundation/Foundation.h>

@interface WikipediaHelper : NSObject {
    NSString *apiUrl;
    NSMutableArray *imageBlackList;
}

@property (nonatomic, retain) NSString *apiUrl;
@property (nonatomic, retain) NSMutableArray *imageBlackList;

// Fetches an wikipedia article (Unformatted HTML Code) from the wikipedia api
- (NSString *) getWikipediaArticle:(NSString *)name;

// Returns the HTML page from an wikipedia article search by the name
- (NSString *) getWikipediaHTMLPage:(NSString *)name;

// Return the Main image of an wikipedia article search by the name
- (NSString *) getUrlOfMainImage:(NSString *)name;

// Checks if the returned image is on the blacklist
- (BOOL) isOnBlackList:(NSString *)imageURL;
- (NSMutableArray *) getWikipediaTranslation:(NSString *)name search:(BOOL)isSearchNative;
@end
