//
//  CroissantQueue.h
//  croissant
//
//  Created by David Martin on 07/06/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CroissantQueueItem <NSObject>

- (void)start;
- (void)cancel;
- (void)invalidate;

@end

@interface CroissantQueue : NSObject

+ (void)setMaxDownloads:(int)maxDownloads;
+ (void)enqueueItem:(NSObject<CroissantQueueItem>*)item;
+ (void)downloadFinishedForItem:(NSObject<CroissantQueueItem> *)item;
+ (void)cancelAll;

@end
