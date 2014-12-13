//
//  CroissantUIImageItem.m
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

#import "CroissantUIImageItem.h"

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

- (void)invokeDownloadDidFailWithError:(NSError *)error
{
    [super invokeDownloadDidFailWithError:error];
    
    if(self.imageBlock)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^
        {
            weakSelf.imageBlock(nil, error);
        });
    }
    
    [CroissantQueue downloadFinishedForItem:self];
}

- (void)invokeDownloadDidComplete:(NSData *)downloadedData
{
    NSString *imageContentType = [CroissantUIImageItem contentTypeForImageData:downloadedData];
    if ([imageContentType isEqualToString:@"image/gif"] ||
        [imageContentType isEqualToString:@"image/webp"])
    {
        [self invokeDownloadDidFailWithString:kCroissantImageErrorString];
    }
    else
    {
        UIImage *image = [[UIImage alloc] initWithData:downloadedData];
        NSError *imageError = nil;
        
        if (image)
        {
            // Force image decompression
            UIGraphicsBeginImageContext(CGSizeMake(1, 1));
            [image drawAtPoint:CGPointZero];
            UIGraphicsEndImageContext();
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^
            {
                if(weakSelf.imageBlock)
                {
                    weakSelf.imageBlock(image, imageError);
                }
            });
        }
        else
        {
            imageError = [NSError errorWithDomain:@"Croissant - image decompression error"
                                             code:1000
                                         userInfo:nil];
            [self invokeDownloadDidFailWithError:imageError];
        }
        
        [CroissantQueue downloadFinishedForItem:self];
    }
}

@end
