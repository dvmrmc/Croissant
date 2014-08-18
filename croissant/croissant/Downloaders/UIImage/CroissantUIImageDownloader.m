//
//  PASDKImageDownloadManager.m
//  PlayAdsSDK
//
//  Created by David Martin on 16/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import "CroissantUIImageDownloader.h"
#import "CroissantDownloaderProtocol.h"

@interface CroissantUIImageDownloader () <CroissantDownloaderProtocol>

@end

@implementation CroissantUIImageDownloader

+ (void)downloadFromURL:(NSURL *)url
            cachePolicy:(CroissantCachePolicy)cachePolicy
             completion:(CroissantUIImageDownloadBlock)completion;
{
    CroissantUIImageItem *item = [[CroissantUIImageItem alloc] init];
    item.managerDelegate = [CroissantUIImageDownloader sharedInstance];
    item.imageBlock = completion;
    item.downloadURL = url;
    item.cachePolicy = cachePolicy;
    [[CroissantUIImageDownloader sharedInstance] downloadItem:item];
}

@end
