//
//  MPMoviePlayerViewController+HZTPlayVideoWindow.h
//  系统相册
//
//  Created by 王新伟 on 2019/8/2.
//  Copyright © 2019年 王新伟. All rights reserved.
//


#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMoviePlayerViewController (HZTPlayVideoWindow)
@property (nonatomic, strong,nullable) UIWindow * alertWindow;
- (void)show;
@end

NS_ASSUME_NONNULL_END
