//
//  CroissantCache.m
//  Created by Csongor Nagy on 15/05/14.
//

#import "CroissantCache.h"
#import <CommonCrypto/CommonDigest.h>

NSString * const kCroissantCacheNamespace = @"croissant.cache";

@implementation CroissantCache

+ (BOOL)cleanCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:[CroissantCache cacheFolder]
                                   error:nil];
}

+ (void)cacheData:(NSData*)data witName:(NSString*)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:[[CroissantCache cacheFolder] stringByAppendingPathComponent:[CroissantCache getCachedNameFromURL:name]]
                         contents:data
                       attributes:nil];
}

+ (BOOL)hasCachedDataWithName:(NSString*)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[[CroissantCache cacheFolder] stringByAppendingPathComponent:[CroissantCache getCachedNameFromURL:name]]];
}

+ (NSData*)cachedDataWithName:(NSString*)name
{
    NSData *data;
    
    if ([CroissantCache hasCachedDataWithName:name])
    {
        data = [NSData dataWithContentsOfFile:[[CroissantCache cacheFolder] stringByAppendingPathComponent:[CroissantCache getCachedNameFromURL:name]]];
    }
    
    return data;
}

+ (NSString*)cacheFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [paths[0] stringByAppendingPathComponent:kCroissantCacheNamespace];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:diskCachePath])
    {
        [fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return diskCachePath;
}

+ (NSString*)getCachedNameFromURL:(NSString*)urlString
{
    if ([urlString length] <= 0) { return nil; }
    
	const char *cStringToHash = [urlString UTF8String];
	unsigned char hash[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStringToHash, (CC_LONG)(strlen(cStringToHash)), hash);
	
	NSMutableString *hashString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
    {
        [hashString appendFormat:@"%02X", hash[i]];
    }
	NSString *result = [NSString stringWithString:hashString];
    return result;
}

@end
