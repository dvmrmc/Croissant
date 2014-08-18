//
//  PASDKImageDownloadManager.h
//  PlayAdsSDK
//
//  Created by David Martin on 16/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import "CroissantNSDataDownloader.h"
#import "CroissantUIImageItem.h"

@interface CroissantUIImageDownloader : CroissantNSDataDownloader

+ (void)downloadFromURL:(NSURL *)url
            cachePolicy:(CroissantCachePolicy)cachePolicy
             completion:(CroissantUIImageDownloadBlock)completion;

@end
