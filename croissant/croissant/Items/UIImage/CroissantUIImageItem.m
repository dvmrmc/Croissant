//
//  PASDKDownloadManagerImageItem.m
//  PlayAdsSDK
//
//  Created by David Martin on 16/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import "CroissantUIImageItem.h"
#import "CroissantCache.h"

NSString * const kCroissantImageErrorString    = @"ImageTypeNotSupported";

@interface CroissantUIImageItem ()

+ (NSString*)contentTypeForImageData:(NSData *)data;

@end

@implementation CroissantUIImageItem

+ (NSString*)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c)
    {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12)
            {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)]
                                                         encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"])
            {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
}

- (void)invokeDownloadDidFail:(NSError *)error
{
    [super invokeDownloadDidFail:error];
    
    if(self.imageBlock)
    {
        dispatch_main_sync(^{
            self.imageBlock(nil, error);
        });
    }
}

- (void)invokeDownloadDidComplete:(NSData *)downloadedData
{
    NSString *imageContentType = [CroissantUIImageItem contentTypeForImageData:downloadedData];
    if ([imageContentType isEqualToString:@"image/gif"] ||
        [imageContentType isEqualToString:@"image/webp"])
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:kCroissantImageErrorString forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:kCroissantImageErrorString code:0 userInfo:userInfo];
        
        [self invokeDownloadDidFail:error];
    }
    else
    {
        [super invokeDownloadDidComplete:downloadedData];
        
        if(self.imageBlock)
        {
            dispatch_main_sync(^{
                self.imageBlock([[UIImage alloc] initWithData:downloadedData], nil);
            });
        }
    }
}

@end
