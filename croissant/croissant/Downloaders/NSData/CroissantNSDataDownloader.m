//
//  PASDKImageManager.m
//  PlayAdsSDK
//
//  Created by David Martin on 15/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import "CroissantNSDataDownloader.h"
#import "CroissantNSDataItem.h"

#pragma mark - PASDKImageManager -

static CroissantNSDataDownloader *_sharedInstance;

@interface CroissantNSDataDownloader ()

@property (nonatomic, strong) NSMutableArray    *downloadQueue;
@property (nonatomic, strong) NSMutableArray    *currentDownloads;
@property (nonatomic, assign) NSInteger         maxDownloads;

@end

@implementation CroissantNSDataDownloader

#pragma mark Instance methods

+ (void)downloadFromURL:(NSURL*)url
            cachePolicy:(CroissantCachePolicy)cachePolicy
             completion:(CroissantNSDataDownloadBlock)completion
{
    CroissantNSDataItem *item = [[CroissantNSDataItem alloc] init];
    item.block = completion;
    item.downloadURL = url;
    item.cachePolicy = cachePolicy;
    [self enqueueItem:item];
}

@end




