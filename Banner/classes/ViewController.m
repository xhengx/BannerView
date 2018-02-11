//
//  ViewController.m
//  Banner
//
//  Created by xheng on 10/2/18.
//  Copyright © 2018年 xheng. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"
#import "BannerModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BannerView *banner = [[BannerView alloc] init];
    banner.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    banner.placeHolderImage = [UIImage imageNamed:@"placeholder"];
//    banner.autoScroll = YES;
    
    BannerModel *b1 = [BannerModel new];
    b1.bannerImageURL = @"http://img.zcool.cn/community/01638059302785a8012193a36096b8.jpg@2o.jpg";
    b1.bannerURL = @"ui://1";
    
    BannerModel *b2 = [BannerModel new];
    b2.bannerImageURL = @"http://img07.tooopen.com/images/20170316/tooopen_sy_201956178977.jpg";
    b2.bannerURL = @"ui://2";
    
    BannerModel *b3 = [BannerModel new];
    b3.bannerImageURL = @"http://img.zcool.cn/community/0142135541fe180000019ae9b8cf86.jpg@1280w_1l_2o_100sh.png";
    b3.bannerURL = @"ui://3";
    
    BannerModel *b4 = [BannerModel new];
    b4.bannerImageURL = @"http://img.taopic.com/uploads/allimg/121019/234917-121019231h258.jpg";
    b4.bannerURL = @"ui://4";
    
    BannerModel *b5 = [BannerModel new];
    b5.bannerImageURL = @"http://img.zcool.cn/community/0142135541fe180000019ae9b8cf86.jpg@1280w_1l_2o_100sh.png";
    b5.bannerURL = @"ui://5";
    
    BannerModel *b6 = [BannerModel new];
    b6.bannerImageURL = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"];
    b6.bannerImageType = BannerImageTypeLocal;
    b6.bannerURL = @"ui://6";
    
    BannerModel *b7 = [BannerModel new];
    b7.bannerImageURL = @"2";
    b7.bannerImageType = BannerImageTypeAssets;
    b7.bannerURL = @"ui://7";
    
    banner.dataSources = @[b7, b1, b2, b6, b3, b5, b6, b4];
    
    [self.view addSubview:banner];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
