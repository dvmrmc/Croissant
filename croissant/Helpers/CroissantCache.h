//
//  CroissantCache.h
//  Created by Csongor Nagy on 15/05/14.
//

#import <Foundation/Foundation.h>

@interface CroissantCache : NSObject

+ (BOOL)cleanCache;
+ (void)cacheData:(NSData*)data witName:(NSString*)name;
+ (BOOL)hasCachedDataWithName:(NSString*)name;
+ (NSData*)cachedDataWithName:(NSString*)name;
+ (NSString*)cacheFolder;
+ (NSString*)getCachedNameFromURL:(NSString*)urlString;

@end