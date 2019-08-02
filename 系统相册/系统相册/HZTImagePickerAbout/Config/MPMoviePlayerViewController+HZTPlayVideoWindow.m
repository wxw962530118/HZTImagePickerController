//
//  MPMoviePlayerViewController+HZTPlayVideoWindow.m
//  系统相册
//
//  Created by 王新伟 on 2019/8/2.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "MPMoviePlayerViewController+HZTPlayVideoWindow.h"
#import <objc/runtime.h>

@implementation MPMoviePlayerViewController (HZTPlayVideoWindow)
@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

- (void)show {
    self.moviePlayer.shouldAutoplay = YES;
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        self.alertWindow.tintColor = delegate.window.tintColor;
    }
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [self.alertWindow makeKeyAndVisible];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.alertWindow.rootViewController presentViewController:self animated:YES completion:nil];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"控制器:%@ 被释放",NSStringFromClass([self class]));
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

@end
