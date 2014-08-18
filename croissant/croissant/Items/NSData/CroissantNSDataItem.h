//
//  PASDKImageManagerItem.h
//  PlayAdsSDK
//
//  Created by David Martin on 15/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Croissant.h"

#define dispatch_main_sync(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

@class CroissantNSDataItem;

@protocol CroissantNSDataItemDelegate <NSObject>

@optional
- (void)download:(CroissantNSDataItem*)item didComplete:(NSData*)downloadedData;
- (void)download:(CroissantNSDataItem*)item didFail:(NSError*)error;

@end

@interface CroissantNSDataItem : NSObject

@property (nonatomic, weak)     NSObject<CroissantNSDataItemDelegate> *managerDelegate;
@property (nonatomic, copy)     CroissantNSDataDownloadBlock                  block;
@property (nonatomic, strong)   NSURL                               *downloadURL;
@property (nonatomic, assign)   CroissantCachePolicy            cachePolicy;

- (void)invokeDownloadDidComplete:(NSData*)downloadedData;
- (void)invokeDownloadDidFail:(NSError*)error;

- (void)start;
- (void)cancel;

@end