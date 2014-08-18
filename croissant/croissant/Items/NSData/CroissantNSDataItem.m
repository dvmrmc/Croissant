//
//  PASDKImageManagerItem.m
//  PlayAdsSDK
//
//  Created by David Martin on 15/05/14.
//  Copyright (c) 2014 AppLift. All rights reserved.
//

#import "CroissantNSDataItem.h"
#import "CroissantCache.h"

NSString * const kPASDKDownloadItemCancelErrorString = @"DownloadCancelled";
NSInteger const kPASDKDownloadItemTimeout = 60;

@interface CroissantNSDataItem () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

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
        
        return;
    }
    
    if (self.cachePolicy == CroissantCachePolicy_UseCache && [CroissantCache hasCachedDataWithName:[self.downloadURL absoluteString]])
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
        [self invokeDownloadDidFail:nil];
    }
}

- (void)cancel
{
    [self.connection cancel];
    self.connection = nil;
    self.receivedData = nil;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:kPASDKDownloadItemCancelErrorString forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:kPASDKDownloadItemCancelErrorString code:0 userInfo:userInfo];
    
    [self invokeDownloadDidFail:error];
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

- (void)invokeDownloadDidFail:(NSError*)error
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
    [self invokeDownloadDidFail:error];
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