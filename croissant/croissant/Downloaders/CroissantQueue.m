//
//  PASDKImageManager.m
//  PlayAdsSDK
//
//  Created by David Martin on 15/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import "CroissantQueue.h"
#import "CroissantNSDataDownloader.h"
#import "CroissantDownloaderProtocol.h"

NSInteger const kCroissantNSDataDefaultMaxDownloads = 5;
static CroissantQueue *_sharedInstance;

@interface CroissantQueue ()< CroissantItemDelegate >

@property (nonatomic, strong) NSMutableArray    *downloadQueue;
@property (nonatomic, strong) NSMutableArray    *currentDownloads;
@property (nonatomic, assign) NSInteger         maxDownloads;

+ (instancetype)sharedInstance;

- (void)download;

@end

@implementation CroissantQueue

#pragma mark Class methods

+ (instancetype)sharedInstance
{
    if(_sharedInstance == nil)
    {
        _sharedInstance = [[CroissantQueue alloc] init];
        _sharedInstance.maxDownloads = kCroissantNSDataDefaultMaxDownloads;
    }
    return _sharedInstance;
}

+ (void)setMaxDownloads:(int)maxDownloads
{
    [CroissantQueue sharedInstance].maxDownloads = maxDownloads;
}

+ (void)enqueueItem:(CroissantItem *)item
{
    item.managerDelegate = [CroissantQueue sharedInstance];
    [[CroissantQueue sharedInstance].downloadQueue addObject:item];
    [[CroissantQueue sharedInstance] download];
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

- (void)enqueueItem:(CroissantItem*)item
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




