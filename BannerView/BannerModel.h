//
//  BannerModel.h
//  Banner
//
//  Created by xheng on 10/2/18.
//  Copyright © 2018年 xheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BannerImageType) {
    BannerImageTypeRemote, //远程图片
    BannerImageTypeLocal, //沙盒图片
    BannerImageTypeAssets, //资源图片
};

@interface BannerModel : NSObject

@property (nonatomic, assign) NSUInteger bannerID;
@property (nonatomic, copy) NSString *bannerImageURL; //图片URL
@property (nonatomic, assign) BannerImageType bannerImageType; //default BannerImageTypeRemote
@property (nonatomic, copy) NSString *bannerURL; //路由URL


@end
