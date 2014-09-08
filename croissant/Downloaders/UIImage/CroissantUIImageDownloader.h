//
//  CroissantUIImageDownloader.h
//  Created by David Martin on 15/05/14.
//

#import "CroissantNSDataDownloader.h"

@interface CroissantUIImageDownloader : CroissantNSDataDownloader

+ (void)downloadFromURL:(NSURL *)url
            cachePolicy:(CroissantCachePolicy)cachePolicy
             completion:(CroissantUIImageDownloadBlock)completion;

@end
