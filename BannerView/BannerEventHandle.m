//
//  BannerEventHandle.m
//  Banner
//
//  Created by xheng on 10/2/18.
//  Copyright © 2018年 xheng. All rights reserved.
//

#import "BannerEventHandle.h"
#import "BannerModel.h"

@implementation BannerEventHandle

static BannerEventHandle *_instance;

+ (instancetype)sharedHandle {
    
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

- (void)bannerView:(BannerView *)banner didItemClicked:(BannerModel *)model {
    NSString *route = model.bannerURL;
    
    NSLog(@"%@", route);
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}



@end
