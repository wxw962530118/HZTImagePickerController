//
//  HZTImageBrowserForceTouchViewController.m
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/7/17.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "HZTImageBrowserForceTouchViewController.h"
#import "HZTImageBrowserHeader.h"
#import "UIImageView+WebCache.h"
@interface HZTImageBrowserForceTouchViewController ()

@end

@implementation HZTImageBrowserForceTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    CGFloat showImageViewW;
    CGFloat showImageViewH;
    CGFloat showImageW = self.showOriginForceImage.size.width;
    CGFloat showImageH = self.showOriginForceImage.size.height;
    if (showImageH/showImageW > Screen_Height/Screen_Width) {
        showImageViewH = Screen_Height;
        showImageViewW = Screen_Height * showImageW/showImageH;
    } else {
        showImageViewW = Screen_Width;
        showImageViewH = Screen_Width * showImageH/showImageW;
    }
    
    UIImageView * showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, showImageViewW, showImageViewH)];
    [showImageView sd_setImageWithURL:[NSURL URLWithString:self.showForceImageUrl] placeholderImage:self.showOriginForceImage];
    showImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:showImageView];
}

/**如果你需要为3Dtouch上滑增加事件 在当前视图控制器重写 下面的方法*/
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    NSMutableArray * previewActionItems = [[NSMutableArray alloc] init];
    __weak HZTImageBrowserForceTouchViewController * weakSelf = self;
    for (NSInteger i = 0; i < self.previewActionTitls.count; i++) {
        UIPreviewAction *previewAction = [UIPreviewAction actionWithTitle:self.previewActionTitls[i] style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            if (weakSelf.forceTouchActionBlock) {
                weakSelf.forceTouchActionBlock(i, weakSelf.previewActionTitls[i]);
            }
        }];
        [previewActionItems addObject:previewAction];
    }
    return [previewActionItems copy];
}

@end
