//
//  CroissantItem.m
//  croissant
//
//  Created by David Martin on 07/06/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

#import "CroissantItem.h"
#import "Croissant.h"
#import "CroissantCache.h"

#define dispatch_main_sync(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

NSString * const kCroissantItemCancelErrorString = @"DownloadCancelled";
NSString * const kCroissantItemBadURLErrorString = @"BadURL";
NSString * const kCroissantItemNoConnectionErrorString = @"NoConnection";

NSInteger const kPASDKDownloadItemTimeout = 60;

@interface CroissantItem ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, copy)     CroissantNSDataDownloadBlock    block;
@property (nonatomic, strong)   NSURL                           *downloadURL;
@property (nonatomic, assign)   CroissantCachePolicy            cachePolicy;

@property (nonatomic, strong)   NSMutableData                   *receivedData;
@property (nonatomic, strong)   NSURLConnection                 *connection;

- (void)invokeDownloadDidComplete:(NSObject*)downloadedObject;
- (void)invokeDownloadDidFailWithString:(NSString*)errorString;
- (void)invokeDownloadDidFailWithError:(NSError*)error;

@end

@implementation CroissantItem

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
                                         timeoutInterval:kPASDKDownloadItemTimeout];
    
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
    [self.connection cancel];
    self.connection = nil;
    self.receivedData = nil;
    
    [self invokeDownloadDidFailWithString:kCroissantItemCancelErrorString];
}

- (void)invokeDownloadDidComplete:(NSData*)downloadedData
{
    if(self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(download:didComplete:)])
    {
        [self.managerDelegate download:self didComplete:downloadedData];
    }
    
    if(self.block)
    {
        dispatch_main_sync(^{
            self.block(downloadedData, nil);
        });
    }
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
    if(self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(download:didFail:)])
    {
        [self.managerDelegate download:self didFail:error];
    }
    
    if(self.block)
    {
        dispatch_main_sync(^{
            self.block(nil, error);
        });
    }
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
