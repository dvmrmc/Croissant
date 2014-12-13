//
//  Croissant.h
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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^CroissantUIImageDownloadBlock)(UIImage *image, NSError *error);
typedef void (^CroissantNSDataDownloadBlock)(NSData *data, NSError *error);

typedef enum
{
    CroissantCachePolicy_UseCache       = 1 << 0,
    CroissantCachePolicy_NoUseCache     = 1 << 1
}CroissantCachePolicy;

@interface Croissant : NSObject

+ (void)setMaxDownloads:(int)maxDownloads;

+ (void)downloadNSDDataFromURLString:(NSString*)url
                         cachePolicy:(CroissantCachePolicy)cachePolicy
                          completion:(CroissantNSDataDownloadBlock)completion;

+ (void)downloadNSDDataFromURL:(NSURL*)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                	completion:(CroissantNSDataDownloadBlock)completion;

+ (void)downloadUIImageFromURLString:(NSString *)url
                         cachePolicy:(CroissantCachePolicy)cachePolicy
                          completion:(CroissantUIImageDownloadBlock)completion;

+ (void)downloadUIImageFromURL:(NSURL *)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                    completion:(CroissantUIImageDownloadBlock)completion;

+ (void)cancelAllDownloads;

@end
