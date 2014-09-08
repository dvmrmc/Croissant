//
//  Croissant.m
//  croissant
//
//  Created by David Martin on 07/06/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

#import "Croissant.h"
#import "CroissantQueue.h"
#import "CroissantUIImageDownloader.h"
#import "CroissantNSDataDownloader.h"

@implementation Croissant

+ (void)setMaxDownloads:(int)maxDownloads
{
    [CroissantQueue setMaxDownloads:maxDownloads];
}

+ (void)downloadNSDDataFromURLString:(NSString*)urlString
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                    completion:(CroissantNSDataDownloadBlock)completion
{
    [self downloadNSDDataFromURL:[NSURL URLWithString:urlString]
                     cachePolicy:cachePolicy
                      completion:completion];
}

+ (void)downloadNSDDataFromURL:(NSURL*)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                completion:(CroissantNSDataDownloadBlock)completion
{
    [CroissantNSDataDownloader downloadFromURL:url
                                   cachePolicy:cachePolicy
                                    completion:completion];
}

+ (void)downloadUIImageFromURLString:(NSString *)urlString
                         cachePolicy:(CroissantCachePolicy)cachePolicy
                          completion:(CroissantUIImageDownloadBlock)completion
{
    [self downloadUIImageFromURL:[NSURL URLWithString:urlString]
                     cachePolicy:cachePolicy
                      completion:completion];
}

+ (void)downloadUIImageFromURL:(NSURL *)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                completion:(CroissantUIImageDownloadBlock)completion
{
    [CroissantUIImageDownloader downloadFromURL:url
                                    cachePolicy:cachePolicy
                                     completion:completion];
}

+ (void)cancelAllDownloads
{
    [CroissantQueue cancelAll];
}

@end
