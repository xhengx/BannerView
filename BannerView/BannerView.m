//
//  BannerView.m
//  Banner
//
//  Created by xheng on 10/2/18.
//  Copyright © 2018年 xheng. All rights reserved.
//

#import "BannerView.h"
#import "BannerModel.h"
#import "BannerEventHandle.h"
#import <UIImageView+WebCache.h>

/** configuration **/
#define CurrentPageTintColor [UIColor redColor]
#define PageTintColor [UIColor whiteColor]
#define BannerHeight CGRectGetHeight(self.bounds)
#define BannerWidth CGRectGetWidth(self.bounds)

@interface UIImageView (BannerView)

- (void)xh_setImageWithItem:(BannerModel *)item placeHolderImage:(UIImage *)placeHolder;

@end

@interface BannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation BannerView


- (instancetype)init {
    if (self = [super init]) {
        _currentIndex = 0;
        _autoScroll = YES;
        _delegate = [BannerEventHandle sharedHandle];
        [self setupSubView];
    }
    return self;
}


- (void)setDataSources:(NSArray<BannerModel *> *)dataSources {
    _dataSources = dataSources;
    [self updateLeftImage:self.dataSources.count - 1 middleImage:0 rightImage:1];
}

- (void)startAutoScroll {
    if (_timer) {
        return ;
    }
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_source_set_timer(_timer, start, 3 * NSEC_PER_SEC, 0); //3秒后开始第一次
    dispatch_source_set_event_handler(_timer, ^{
        [self scrollByTimer];
    });
    dispatch_resume(_timer);
}

- (void)scrollByTimer {
    CGPoint offset = CGPointMake(self.scrollView.contentOffset.x + BannerWidth, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSInteger left = 0, middle = 0, right = 0;
    BOOL reset = NO;
    if (offset.x >= BannerWidth * 2) {
        reset = YES;
        _currentIndex ++;
        if (_currentIndex == self.dataSources.count - 1) {
            left = _currentIndex - 1; middle = _currentIndex; right = 0;
        } else if (_currentIndex == self.dataSources.count) {
            _currentIndex = 0;
            left = self.dataSources.count - 1; middle = _currentIndex; right = 1;
        } else {
            left = _currentIndex - 1; middle = _currentIndex; right = _currentIndex + 1;
        }
    } else if (offset.x <= 0) {
        reset = YES;
        _currentIndex --;
        if (_currentIndex == 0) {
            left = self.dataSources.count - 1; middle = 0; right = 1;
        } else if (_currentIndex == -1) {
            _currentIndex = self.dataSources.count - 1;
            left = _currentIndex - 1; middle = _currentIndex; right = 0;
        } else {
            left = _currentIndex - 1; middle = _currentIndex; right = _currentIndex + 1;
        }
    }
    if (reset) {
        [self updateLeftImage:left middleImage:middle rightImage:right];
        self.scrollView.contentOffset = CGPointMake(BannerWidth, 0);
    }
    self.pageControl.currentPage = _currentIndex;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isAutoScroll) {
        [self stopAutoScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isAutoScroll) {
        [self startAutoScroll];
    }
}

#pragma mark - Action
- (void)bannerClick:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(bannerView:didItemClicked:)]) {
        [_delegate bannerView:self didItemClicked:self.dataSources[_currentIndex]];
    }
}

- (void)stopAutoScroll {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)updateLeftImage:(NSInteger)left middleImage:(NSInteger)middle rightImage:(NSInteger)right {
    if (self.dataSources.count == 1) {
        left = middle = right = 0;
    }
    [self.leftImageView xh_setImageWithItem:self.dataSources[left] placeHolderImage:_placeHolderImage];
    [self.middleImageView xh_setImageWithItem:self.dataSources[middle] placeHolderImage:_placeHolderImage];
    [self.rightImageView xh_setImageWithItem:self.dataSources[right] placeHolderImage:_placeHolderImage];
}


#pragma mark - UI
- (void)setupSubView {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    [self addSubview:self.pageControl];
}


- (void)layoutSubviews {
    [super layoutSubviews];

    self.scrollView.frame = CGRectMake(0, 0, BannerWidth, BannerHeight);
    self.pageControl.frame = CGRectMake(0, BannerHeight - 30, BannerWidth, 30);
    self.leftImageView.frame = CGRectMake(BannerWidth * 0, 0, BannerWidth, BannerHeight);
    self.middleImageView.frame = CGRectMake(BannerWidth * 1, 0, BannerWidth, BannerHeight);
    self.rightImageView.frame = CGRectMake(BannerWidth * 2, 0, BannerWidth, BannerHeight);
    
    self.scrollView.contentSize = CGSizeMake(BannerWidth * 3, 0);
    self.scrollView.contentOffset = CGPointMake(BannerWidth * 1, 0); //设置中间为第一页
    
    self.pageControl.numberOfPages = self.dataSources.count;
    
    if (self.isAutoScroll) {
        if (self.dataSources.count > 1) {
            [self startAutoScroll];
        } else {
            [self stopAutoScroll];
            self.scrollView.scrollEnabled = NO;
            self.pageControl.hidden = YES;
        }
    } else {
        if (self.dataSources.count > 1) {
            [self stopAutoScroll];
        } else {
            [self stopAutoScroll];
            self.scrollView.scrollEnabled = NO;
            self.pageControl.hidden = YES;
        }
    }
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [self contentImageView];
    }
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [self contentImageView];
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [self contentImageView];
    }
    return _rightImageView;
}


- (UIImageView *)contentImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, BannerWidth, BannerHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClick:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = PageTintColor;
        _pageControl.currentPageIndicatorTintColor = CurrentPageTintColor;
    }
    return _pageControl;
}

@end


@implementation UIImageView (BannerView)

- (void)xh_setImageWithItem:(BannerModel *)item placeHolderImage:(UIImage *)placeHolder {
    
    switch (item.bannerImageType) {
        case BannerImageTypeRemote:
        {
            NSURL *url = [NSURL URLWithString:item.bannerImageURL];
            [self sd_setImageWithURL:url placeholderImage:placeHolder];
            break;
        }
        case BannerImageTypeLocal:
        {
            self.image = [UIImage imageWithContentsOfFile:item.bannerImageURL];
            break;
        }
        case BannerImageTypeAssets:
        {
            self.image = [UIImage imageNamed:item.bannerImageURL];
            break;
        }
    }
}

@end
