//
//  CroissantQueue.m
//  Created by David Martin on 15/05/14.
//

#import "CroissantQueue.h"

NSInteger const kCroissantQueueDefaultMaxDownloads = 5;
static CroissantQueue *_sharedInstance;

@interface CroissantQueue ()

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
        _sharedInstance.maxDownloads = kCroissantQueueDefaultMaxDownloads;
    }
    return _sharedInstance;
}

+ (void)cancelAll
{
    [CroissantQueue sharedInstance].downloadQueue = [[NSMutableArray alloc] init];
    for (NSObject<CroissantQueueItem> *item in [CroissantQueue sharedInstance].currentDownloads)
    {
        [item invalidate];
    }
    [CroissantQueue sharedInstance].currentDownloads = [[NSMutableArray alloc] init];
}

+ (void)setMaxDownloads:(int)maxDownloads
{
    [CroissantQueue sharedInstance].maxDownloads = maxDownloads;
}

+ (void)enqueueItem:(NSObject<CroissantQueueItem> *)item
{
    [[CroissantQueue sharedInstance].downloadQueue addObject:item];
    [[CroissantQueue sharedInstance] download];
}

+ (void)downloadFinishedForItem:(NSObject<CroissantQueueItem> *)item
{
    [[CroissantQueue sharedInstance].currentDownloads removeObject:item];
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

- (void)download
{
    if([self.currentDownloads count] >= self.maxDownloads)
    {
        return; // Too much downloads in queue
    }
    
    if([self.downloadQueue count] > 0)
    {
        NSObject<CroissantQueueItem> *nextItem = [self.downloadQueue firstObject];
        [self.currentDownloads addObject:nextItem];
        [self.downloadQueue removeObject:nextItem];
        [nextItem start];
    }
}

@end




