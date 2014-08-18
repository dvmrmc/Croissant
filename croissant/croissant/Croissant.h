//
//  Croissant.h
//  croissant
//
//  Created by David Martin on 07/06/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

typedef void (^CroissantUIImageDownloadBlock)(UIImage *image, NSError *error);
typedef void (^CroissantNSDataDownloadBlock)(NSData *data, NSError *error);

typedef enum
{
    CroissantCachePolicy_UseCache       = 1 << 0,
    CroissantCachePolicy_NoUseCache     = 1 << 1
}CroissantCachePolicy;

@interface Croissant : NSObject

+ (void)setMaxDownloads:(int)maxDownloads;

+ (void)downloadNSDDataFromURLString:(NSString*)url
                         cachePolicy:(CroissantCachePolicy)cachePolicy
                          completion:(CroissantNSDataDownloadBlock)completion;

+ (void)downloadNSDDataFromURL:(NSURL*)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                	completion:(CroissantNSDataDownloadBlock)completion;

+ (void)downloadUIImageFromURLString:(NSString *)url
                         cachePolicy:(CroissantCachePolicy)cachePolicy
                          completion:(CroissantUIImageDownloadBlock)completion;

+ (void)downloadUIImageFromURL:(NSURL *)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                    completion:(CroissantUIImageDownloadBlock)completion;

@end
