//
//  CroissantDownloaderProtocol.h
//  croissant
//
//  Created by David Martin on 07/06/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CroissantNSDataItem.h"

@protocol CroissantDownloaderProtocol <NSObject>

+ (instancetype)sharedInstance;
- (void)downloadItem:(CroissantNSDataItem*)item;

@end
