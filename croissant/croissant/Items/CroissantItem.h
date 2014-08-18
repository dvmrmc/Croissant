//
//  CroissantItem.h
//  croissant
//
//  Created by David Martin on 07/06/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CroissantItem;

@protocol CroissantItemDelegate <NSObject>

@optional
- (void)download:(CroissantItem*)item didComplete:(NSObject*)downloadedObject;
- (void)download:(CroissantItem*)item didFail:(NSError*)error;

@end

@interface CroissantItem : NSObject

@property (nonatomic, weak)     NSObject<CroissantItemDelegate> *managerDelegate;

- (void)start;
- (void)cancel;

@end
