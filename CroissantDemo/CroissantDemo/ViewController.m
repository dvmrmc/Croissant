//
//  ViewController.m
//  CroissantDemo
//
//  Created by David Martin on 13/12/14.
//  Copyright (c) 2014 cerberillo. All rights reserved.
//

#import "ViewController.h"
#import "Croissant.h"

NSString * const kFlickrSearchURL = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=aad15b739d51f7991102b261a8a5b85f&text=croissant&format=json&nojsoncallback=1";

// farm, server, id, secret
NSString * const kFlickrPhotoFormatURL = @"https://farm%@.staticflickr.com/%@/%@_%@.jpg";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *photos;

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    [Croissant downloadNSDDataFromURLString:kFlickrSearchURL
                                cachePolicy:CroissantCachePolicy_NoUseCache completion
                                           :^(NSData *data, NSError *error)
    {
        if(error)
        {
            // Something happened
        }
        else
        {
            NSError *jsonError = nil;
            NSDictionary *flickrResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&jsonError];
            
            if(jsonError)
            {
                // Something happened when decoding the json
            }
            else
            {
                weakSelf.photos = flickrResponse[@"photos"][@"photo"];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if(self.photos)
    {
        result = [self.photos count];
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"photoCell";
    __block UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellID];
    }
    
    NSDictionary *photo = (NSDictionary*) self.photos[indexPath.row];
    [cell.textLabel setText:photo[@"title"]];
    [cell.imageView setImage:nil];
    NSString *photoURL = [NSString stringWithFormat:kFlickrPhotoFormatURL,
                                                    photo[@"farm"],
                                                    photo[@"server"],
                                                    photo[@"id"],
                                                    photo[@"secret"]];
    
    
    [Croissant downloadUIImageFromURLString:photoURL
                                cachePolicy:CroissantCachePolicy_NoUseCache
                                 completion:^(UIImage *image, NSError *error)
    {
        if(error)
        {
            NSLog(@"Croissant - image error: %@", error);
        }
        else
        {
            NSLog(@"Croissant - image downloaded");
            [cell.imageView setImage:image];
        }
    }];
    
    return cell;
}

@end
