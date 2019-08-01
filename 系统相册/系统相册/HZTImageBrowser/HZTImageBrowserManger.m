//
//  HZTImageBrowserManger.m
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "HZTImageBrowserManger.h"
#import "HZTImageBrowserForceTouchViewController.h"
#import "HZTImageBrowserViewController.h"
#import "HZTImageBrowserHeader.h"

@interface HZTImageBrowserManger ()<UIViewControllerPreviewingDelegate>
@property(nonatomic,copy)NSArray <HZTImageBrowserModel *>* browserModels;
@property(nonatomic,copy)NSArray * originImageViews;

@property(nonatomic,weak)UIViewController * controller;
@property(nonatomic,copy)ForceTouchActionBlock forceTouchActionBlock;
@property(nonatomic,copy)NSArray * previewActionTitls;
/***/
@property (nonatomic, assign) BOOL isFromPicker;
@end
@implementation HZTImageBrowserManger
+(HZTImageBrowserManger *)imageBrowserMangerWithUrlStr:(NSArray<HZTImageBrowserModel *> *)browserModels originController:(UIViewController *)controller isFromPicker:(BOOL)isFromPicker{
    return [self imageBrowserMangerWithUrlStr:browserModels originImageViews:nil originController:controller isFromPicker:isFromPicker];
}

+(HZTImageBrowserManger *)imageBrowserMangerWithUrlStr:(NSArray<HZTImageBrowserModel *>*)browserModels originImageViews:(NSArray<UIImageView *> *)originImageViews originController:(UIViewController *)controller isFromPicker:(BOOL)isFromPicker{
    return [self imageBrowserMangerWithUrlStr:browserModels originImageViews:originImageViews originController:controller isFromPicker:isFromPicker forceTouch:NO forceTouchActionTitles:nil forceTouchActionComplete:nil];
}

+ (HZTImageBrowserManger *)imageBrowserMangerWithUrlStr:(NSArray<HZTImageBrowserModel *>*)browserModels originImageViews:(NSArray<UIImageView *>*)originImageViews originController:(UIViewController *)controller isFromPicker:(BOOL)isFromPicker forceTouch:(BOOL)forceTouchCapability forceTouchActionTitles:(nullable NSArray <NSString *>*)titles forceTouchActionComplete:(nullable ForceTouchActionBlock)forceTouchActionBlock {
    HZTImageBrowserManger * imageBrowserManger = [[HZTImageBrowserManger alloc] init];
    imageBrowserManger.isFromPicker = isFromPicker;
    imageBrowserManger.browserModels = browserModels;
    imageBrowserManger.originImageViews = originImageViews;
    imageBrowserManger.controller = controller;
    if (forceTouchCapability) {
        [imageBrowserManger initForceTouch];
    }
    if (forceTouchCapability && titles.count) {
        imageBrowserManger.previewActionTitls = titles;
        imageBrowserManger.forceTouchActionBlock = forceTouchActionBlock;
    }
    return imageBrowserManger;
}

- (void)showImageBrowser {
    HZTImageBrowserViewController * imageBrowserViewController = [[HZTImageBrowserViewController alloc] initWithUrlStr:self.browserModels originImageViews:self.originImageViews selectPage:self.selectPage originImageView:self.originImageView isFromPicker:self.isFromPicker];
    [self.controller presentViewController:imageBrowserViewController animated:YES completion:nil];
}

- (void)initForceTouch {
    if ([self.controller respondsToSelector:@selector(traitCollection)]) {
        if ([self.controller.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.controller.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                //1.注册3Dtouch事件
                for (UIView * view in self.originImageViews) {
                    [self.controller registerForPreviewingWithDelegate:self sourceView:view];
                }
            }
        }
    }
}

#pragma mark --UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSInteger selectPage = [self.originImageViews indexOfObject:[previewingContext sourceView]];
    self.selectPage = selectPage;
    UIImage * showOriginForceImage = (UIImage *)[self.originImageViews[selectPage] image];
    NSString * showForceImageUrl = self.browserModels[selectPage].urlStr;
    HZTImageBrowserForceTouchViewController * forceTouchController = [[HZTImageBrowserForceTouchViewController alloc] init];
    forceTouchController.showOriginForceImage = showOriginForceImage;
    forceTouchController.showForceImageUrl = showForceImageUrl;
    if (self.previewActionTitls.count) {
        forceTouchController.previewActionTitls = self.previewActionTitls;
        forceTouchController.forceTouchActionBlock = self.forceTouchActionBlock;
    }
    CGFloat showImageViewW;
    CGFloat showImageViewH;
    CGFloat showImageW = showOriginForceImage.size.width;
    CGFloat showImageH = showOriginForceImage.size.height;
    if (showImageH/showImageW > Screen_Height/Screen_Width) {
        showImageViewH = Screen_Height;
        showImageViewW = Screen_Height * showImageW/showImageH;
    } else {
        showImageViewW = Screen_Width;
        showImageViewH = Screen_Width * showImageH/showImageW;
    }
    //设置展示大小
    forceTouchController.preferredContentSize = CGSizeMake((showImageViewW-2)/1, (showImageViewH-2)/1);
    
    return forceTouchController;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    HZTImageBrowserViewController * imageBrowserViewController = [[HZTImageBrowserViewController alloc] initWithUrlStr:self.browserModels originImageViews:self.originImageViews selectPage:self.selectPage originImageView:self.originImageView isFromPicker:self.isFromPicker];
    [self.controller presentViewController:imageBrowserViewController animated:NO completion:nil];
}

@end
