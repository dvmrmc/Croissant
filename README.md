# ![test](http://goo.gl/4PSkha "Le Croissant") Croissant
This library is a simple queued downloader written in Objective-C and released under MIT License, so feel free to use and PullRequest any bug fix or new behaviour added.

## Install
Download or clone the project master branch and include everything under "croissant/croissant" folder into your project.

## Usage
This library provides 2 basic types download. This creates a queue to avoid performance issues when downloading too many resources at the same time. 

### Configure
* By setting up the max amount of parallel downloads (5 by default)

```objectivec
[Croissant setMaxDownloads:10];
```

### Download
* Download raw NSData from either NSURL or NSString

```objectivec
NSURL *url = [NSURL URLWithString:@"<YOUR_RESOURCE_URL_STRING>"];
[Croissant downloadNSDDataFromURL:url
                      cachePolicy:CroissantCachePolicy_NoUseCache
                       completion:^(NSData *data, NSError *error) {
                                    if(error)
                                    {
                                        // Something bad happened with your download
                                    }
                                    else
                                    {
                                        // data is ready
                                    }
                                }];
```

* Download an UIImage from either NSURL or NSString

```objectivec
NSURL *url = [NSURL URLWithString:@"<YOUR_RESOURCE_URL_STRING>"];
[Croissant downloadUIImageFromURL:url
                      cachePolicy:CroissantCachePolicy_NoUseCache
                       completion:^(UIImage *image, NSError *error) {
                                    if(error)
                                    {
                                        // Something bad happened with your download
                                    }
                                    else
                                    {
                                        // image is ready
                                    }
                                }];
```

* To configure download cache policy, you need to use (**CroissantCachePolicy** cachePolicy) parameter
    * **CroissantCachePolicy_NoUseCache**: This forces the download independently of what the cache has in the store (overwriting it in case something is cached)
    * **CroissantCachePolicy_UseCache**: This returns inmediatly what's stored in the cache in case something is stored.

## Author
* Created by [David Martin](http://www.github.com/cerberillo)
* Special thanks to [Csongor Nagy](http://www.github.com/ncsongor) for his amazing Cache ;)

## License 

This library is released under MIT License

