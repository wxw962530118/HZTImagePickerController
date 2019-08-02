//
//  HZTImageBrowserViewController.m
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "HZTImageBrowserViewController.h"
#import "HZTImageBrowserMainView.h"
#import "HZTImageBrowserTranslation.h"
#import "HZTImageBrowserHeader.h"

@interface HZTImageBrowserViewController ()<UIViewControllerTransitioningDelegate, HZTImageBrowserMainViewDelegate>
@property(nonatomic,copy)NSArray <HZTImageBrowserModel *>* browserModels;
@property(nonatomic,copy)NSArray * originImageViews;
@property(nonatomic,assign)NSInteger selectPage; ///< 选中哪一个imageView

@property(nonatomic,strong)HZTImageBrowserMainView * browserMainView;
@property(nonatomic,strong)HZTImageBrowserTranslation *browserTranslation;
@property(nonatomic,strong)UIViewController * controller;
/***/
@property (nonatomic, assign) BOOL isFromPicker;
@end

@implementation HZTImageBrowserViewController
- (instancetype)initWithUrlStr:(NSArray<HZTImageBrowserModel *>*)browserModels originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage isFromPicker:(BOOL)isFromPicker{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = self;
        self.isFromPicker = isFromPicker;
        self.browserModels = browserModels;
        self.originImageViews = originImageViews;
        self.selectPage = selectPage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    [self.view addSubview:self.browserMainView];
}

#pragma mark --HZTImageBrowserMainViewDelegate
/* 单击 后的操作 */
- (void)imageBrowserMianViewSingleTapWithModel:(HZTImageBrowserModel *)imageBrowserModel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/* 改变主视图 的 透明度 */
- (void)imageBrowserMainViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
}

#pragma mark --UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.browserTranslation.isBrowserMainView = YES;
    return self.browserTranslation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.browserTranslation.isBrowserMainView = NO;
    return self.browserTranslation;
}


#pragma mark --- lazy
- (HZTImageBrowserMainView *)browserMainView {
    if (_browserMainView == nil) {
        _browserMainView = [HZTImageBrowserMainView imageBrowserMainViewUrlStr:self.browserModels originImageViews:self.originImageViews selectPage:self.selectPage isFromPicker:self.isFromPicker];
        _browserMainView.delegate = self;
    }
    return _browserMainView;
}

- (HZTImageBrowserTranslation *)browserTranslation {
    if (_browserTranslation == nil) {
        _browserTranslation = [[HZTImageBrowserTranslation alloc] init];
        _browserTranslation.mainBrowserMainView = self.browserMainView;
        _browserTranslation.browserControllerView = self.view;
    }
    return _browserTranslation;
}

@end
