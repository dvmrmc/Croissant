//
//  Croissant.m
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

#import "Croissant.h"
#import "CroissantQueue.h"
#import "CroissantUIImageDownloader.h"
#import "CroissantNSDataDownloader.h"

@implementation Croissant

+ (void)setMaxDownloads:(int)maxDownloads
{
    [CroissantQueue setMaxDownloads:maxDownloads];
}

+ (void)downloadNSDDataFromURLString:(NSString*)urlString
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                    completion:(CroissantNSDataDownloadBlock)completion
{
    [self downloadNSDDataFromURL:[NSURL URLWithString:urlString]
                     cachePolicy:cachePolicy
                      completion:completion];
}

+ (void)downloadNSDDataFromURL:(NSURL*)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                completion:(CroissantNSDataDownloadBlock)completion
{
    [CroissantNSDataDownloader downloadFromURL:url
                                   cachePolicy:cachePolicy
                                    completion:completion];
}

+ (void)downloadUIImageFromURLString:(NSString *)urlString
                         cachePolicy:(CroissantCachePolicy)cachePolicy
                          completion:(CroissantUIImageDownloadBlock)completion
{
    [self downloadUIImageFromURL:[NSURL URLWithString:urlString]
                     cachePolicy:cachePolicy
                      completion:completion];
}

+ (void)downloadUIImageFromURL:(NSURL *)url
                   cachePolicy:(CroissantCachePolicy)cachePolicy
                completion:(CroissantUIImageDownloadBlock)completion
{
    [CroissantUIImageDownloader downloadFromURL:url
                                    cachePolicy:cachePolicy
                                     completion:completion];
}

+ (void)cancelAllDownloads
{
    [CroissantQueue cancelAll];
}

@end
