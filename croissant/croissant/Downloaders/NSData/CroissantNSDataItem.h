//
//  CroissantNSDataItem.h
//  croissant
//
//  Created by David Martin on 07/06/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Croissant.h"
#import "CroissantQueue.h"

#define dispatch_main_sync(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

@interface CroissantNSDataItem : NSObject < CroissantQueueItem >

@property (nonatomic, copy)     CroissantNSDataDownloadBlock            block;
@property (nonatomic, assign)   CroissantCachePolicy                    cachePolicy;
@property (nonatomic, strong)   NSURL                                   *downloadURL;

- (void)start;
- (void)cancel;
- (void)invalidate;

- (void)invokeDownloadDidComplete:(NSData*)downloadedData;
- (void)invokeDownloadDidFailWithString:(NSString*)errorString;
- (void)invokeDownloadDidFailWithError:(NSError*)error;

@end