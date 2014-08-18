//
//  PASDKImageManager.m
//  PlayAdsSDK
//
//  Created by David Martin on 15/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import "CroissantNSDataDownloader.h"
#import "CroissantDownloaderProtocol.h"

#pragma mark - PASDKImageManager -

NSInteger const kCroissantNSDataDefaultMaxDownloads = 5;
static CroissantNSDataDownloader *_sharedInstance;

@interface CroissantNSDataDownloader ()<CroissantDownloaderProtocol, CroissantNSDataItemDelegate>

@property (nonatomic, strong) NSMutableArray    *downloadQueue;
@property (nonatomic, strong) NSMutableArray    *currentDownloads;
@property (nonatomic, assign) NSInteger         maxDownloads;

- (void)download;

@end

@implementation CroissantNSDataDownloader

#pragma mark Class methods

+ (instancetype)sharedInstance
{
    if(_sharedInstance == nil)
    {
        _sharedInstance = [[CroissantNSDataDownloader alloc] init];
        _sharedInstance.maxDownloads = kCroissantNSDataDefaultMaxDownloads;
    }
    return _sharedInstance;
}

+ (void)setMaxDownloads:(int)maxDownloads
{
    [CroissantNSDataDownloader sharedInstance].maxDownloads = maxDownloads;
}

+ (void)downloadFromURL:(NSURL*)url
            cachePolicy:(CroissantCachePolicy)cachePolicy
             completion:(CroissantNSDataDownloadBlock)completion
{
    CroissantNSDataItem *item = [[CroissantNSDataItem alloc] init];
    item.managerDelegate = [CroissantNSDataDownloader sharedInstance];
    item.block = completion;
    item.downloadURL = url;
    item.cachePolicy = cachePolicy;
    [[CroissantNSDataDownloader sharedInstance] downloadItem:item];
}

#pragma mark Instance methods

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.downloadQueue = [[NSMutableArray alloc] init];
        self.currentDownloads = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.downloadQueue = nil;
    self.currentDownloads = nil;
}

- (void)downloadItem:(CroissantNSDataItem *)item
{
    [self.downloadQueue addObject:item];
    [self download];
}

- (void)download
{
    if([self.currentDownloads count] >= self.maxDownloads)
    {
        return; // Too much downloads in queue
    }
    
    if([self.downloadQueue count] > 0)
    {
        CroissantNSDataItem *nextItem = [self.downloadQueue firstObject];
        [self.currentDownloads addObject:nextItem];
        [self.downloadQueue removeObject:nextItem];
        [nextItem start];
    }
}

#pragma mark PASDKImageManagerDelegate

- (void)download:(CroissantNSDataItem *)item didComplete:(NSData *)downloadedData
{
    [self.currentDownloads removeObject:item];
    [self download];
}

- (void)download:(CroissantNSDataItem *)item didFail:(NSError *)error
{
    [self.currentDownloads removeObject:item];
    [self download];
}

@end




