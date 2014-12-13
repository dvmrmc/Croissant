//
//  CroissantQueue.m
//  Created by David Martin on 15/05/14.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// 	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// 	THE SOFTWARE.

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




