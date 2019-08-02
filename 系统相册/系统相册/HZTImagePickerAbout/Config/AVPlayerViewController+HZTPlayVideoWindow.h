//
//  AVPlayerViewController+HZTPlayVideoWindow.h
//  系统相册
//
//  Created by 王新伟 on 2019/8/2.
//  Copyright © 2019年 王新伟. All rights reserved.
//


#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerViewController (HZTPlayVideoWindow)
@property (nonatomic, strong,nullable) UIWindow *alertWindow;
- (void)playVideoWithURL:(NSURL *)videoURL;
@end

NS_ASSUME_NONNULL_END
