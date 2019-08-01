//
//  HZTToastView.m
//  系统相册
//
//  Created by 王新伟 on 2019/8/1.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTToastView.h"
#import "ToolBaseClass.h"
#define RootWindow [UIApplication sharedApplication].delegate.window
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface HZTToastView ()
/***/
@property (nonatomic, strong) UILabel * toastLabel;

@end

@implementation HZTToastView

+(void)showToast:(NSString *)toast{
    [self showToast:toast duration:2.0];
}

+(void)showToast:(NSString *)toast duration:(double)duration{
    HZTToastView * view = [[HZTToastView alloc] initWithFrame:CGRectZero];
    [view configWithToast:toast];
    view.toastLabel.text = toast;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration/2 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    });
}

-(void)configWithToast:(NSString *)toast{
    CGFloat toastH = 36;
    CGFloat toastW = [ToolBaseClass getWidthWithString:toast font:[UIFont systemFontOfSize:17]] + 20;
    if (toastW > kScreenW - 40) {
        toastW = kScreenW - 40;
        toastH = [ToolBaseClass getHeightWithString:toast width:kScreenW - 40 font:[UIFont systemFontOfSize:17]];
    }
    CGFloat toastX = (kScreenW - toastW)/2;
    CGFloat toastY = (kScreenH - toastH)/2;
    self.layer.cornerRadius = 5;
    self.frame = CGRectMake(toastX, toastY, toastW, toastH);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [RootWindow addSubview:self];
}

-(UILabel *)toastLabel{
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _toastLabel.numberOfLines = 0;
        _toastLabel.font = [UIFont systemFontOfSize:17];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.textColor = [UIColor whiteColor];
        [self addSubview:_toastLabel];
    }
    return _toastLabel;
}

@end
