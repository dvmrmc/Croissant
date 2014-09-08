//
//  CroissantUIImageDownloader.m
//  Created by David Martin on 15/05/14.
//

#import "CroissantUIImageDownloader.h"
#import "CroissantUIImageItem.h"

@interface CroissantUIImageDownloader ()

@end

@implementation CroissantUIImageDownloader

+ (void)downloadFromURL:(NSURL *)url
            cachePolicy:(CroissantCachePolicy)cachePolicy
             completion:(CroissantUIImageDownloadBlock)completion;
{
    CroissantUIImageItem *item = [[CroissantUIImageItem alloc] init];
    item.imageBlock = completion;
    item.downloadURL = url;
    item.cachePolicy = cachePolicy;
    [self enqueueItem:item];
}

@end
