//
//  CroissantNSDataItem.m
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

#import "CroissantNSDataItem.h"
#import "CroissantCache.h"

NSString * const    kCroissantItemCancelErrorString = @"DownloadCancelled";
NSString * const    kCroissantItemBadURLErrorString = @"BadURL";
NSString * const    kCroissantItemNoConnectionErrorString = @"NoConnection";

NSInteger const     kCroissantItemDownloadTimeout = 60;

@interface CroissantNSDataItem ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong)   NSMutableData                           *receivedData;
@property (nonatomic, strong)   NSURLConnection                         *connection;

@end

@implementation CroissantNSDataItem

- (void)dealloc
{
    [self.connection cancel];
    self.connection = nil;
    
    self.receivedData = nil;
    self.downloadURL = nil;
}

- (void)start
{
    if(self.downloadURL == nil)
    {
        [self invokeDownloadDidFailWithString:kCroissantItemBadURLErrorString];
        return;
    }
    
    if (self.cachePolicy == CroissantCachePolicy_UseCache &&
        [CroissantCache hasCachedDataWithName:[self.downloadURL absoluteString]])
    {
        NSData  *cacheData = [CroissantCache cachedDataWithName:[self.downloadURL absoluteString]];
        [self invokeDownloadDidComplete:cacheData];
        return;
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.downloadURL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:kCroissantItemDownloadTimeout];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.receivedData = [NSMutableData dataWithCapacity:0];
    
    if (self.connection)
    {
        [self.connection start];
    }
    else
    {
        self.receivedData = nil;
        [self invokeDownloadDidFailWithString:kCroissantItemNoConnectionErrorString];
    }
}

- (void)cancel
{
    [self invalidate];
    [self invokeDownloadDidFailWithString:kCroissantItemCancelErrorString];
}

- (void)invalidate
{
    [self.connection cancel];
    self.connection = nil;
    self.receivedData = nil;
}

- (void)invokeDownloadDidComplete:(NSData*)downloadedData
{
    if(self.block)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.block(downloadedData, nil);
        });
    }
    
    [CroissantQueue downloadFinishedForItem:self];
}

- (void)invokeDownloadDidFailWithString:(NSString *)errorString
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:errorString forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:errorString
                                         code:0
                                     userInfo:userInfo];
    
    [self invokeDownloadDidFailWithError:error];
}

- (void)invokeDownloadDidFailWithError:(NSError *)error
{
    if(self.block)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
            self.block(nil, error);
        });
    }
    
    [CroissantQueue downloadFinishedForItem:self];
}

#pragma mark - DELEGATES -

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.receivedData = nil;
    [self invokeDownloadDidFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [CroissantCache cacheData:self.receivedData witName:[self.downloadURL absoluteString]];
    [self invokeDownloadDidComplete:self.receivedData];
    
    self.connection = nil;
    self.receivedData = nil;
}


@end
