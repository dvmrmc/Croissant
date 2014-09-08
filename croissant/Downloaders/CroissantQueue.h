//
//  CroissantQueue.h
//  Created by David Martin on 15/05/14.
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
