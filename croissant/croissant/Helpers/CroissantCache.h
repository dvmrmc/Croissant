//
//  PASDKImageManagerCache.h
//  PlayAdsSDK
//
//  Created by David Martin on 15/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
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
