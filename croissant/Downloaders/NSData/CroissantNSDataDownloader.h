//
//  CroissantNSDataDownloader.h
//  Created by David Martin on 15/05/14.
//

#import <Foundation/Foundation.h>
#import "Croissant.h"
#import "CroissantQueue.h"

@interface CroissantNSDataDownloader : CroissantQueue

+ (void)downloadFromURL:(NSURL*)url
            cachePolicy:(CroissantCachePolicy)cachePolicy
             completion:(CroissantNSDataDownloadBlock)completion;

@end