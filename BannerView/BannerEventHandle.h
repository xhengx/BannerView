//
//  BannerEventHandle.h
//  Banner
//
//  Created by xheng on 10/2/18.
//  Copyright © 2018年 xheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerView.h"

@interface BannerEventHandle : NSObject <BannerViewDelegate>

+ (instancetype)sharedHandle;

@end
