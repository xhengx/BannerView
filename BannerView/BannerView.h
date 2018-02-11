//
//  BannerView.h
//  Banner
//
//  Created by xheng on 10/2/18.
//  Copyright © 2018年 xheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate;
@class BannerModel;

@interface BannerView : UIView

@property (nonatomic, strong) NSArray<BannerModel *> *dataSources; //数据源
@property (nonatomic, assign,getter=isAutoScroll) BOOL autoScroll; //是否自动滚动, 默认YES
@property (nonatomic, strong) UIImage *placeHolderImage; //占位图


@property (nonatomic, weak) id<BannerViewDelegate> delegate;

@end


@protocol BannerViewDelegate <NSObject>

@optional
- (void)bannerView:(BannerView *)banner didItemClicked:(BannerModel *)model;

@end
