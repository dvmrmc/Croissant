//
//  ViewController.m
//  CroissantTest
//
//  Created by David Martin on 18/08/14.
//  Copyright (c) 2014 applift. All rights reserved.
//

#import "ViewController.h"
#import "Croissant.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Croissant downloadUIImageFromURLString:@"http://goo.gl/4PSkha"
                                cachePolicy:CroissantCachePolicy_NoUseCache
                                 completion:^(UIImage *image, NSError *error) {
                                     
                                     if(image)
                                     {
                                         UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                                         imageView.center = self.view.center;
                                         [self.view addSubview:imageView];
                                     }
                                     else
                                     {
                                         NSLog(@"ERROR - %@", error);
                                     }
                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
