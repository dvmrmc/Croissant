//
//  CroissantNSDataItem.m
//  Created by David Martin on 15/05/14.
//

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
        dispatch_main_sync(^{
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
        dispatch_main_sync(^{
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
