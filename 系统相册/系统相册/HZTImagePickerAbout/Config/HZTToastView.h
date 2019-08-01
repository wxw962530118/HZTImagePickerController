//
//  HZTToastView.h
//  系统相册
//
//  Created by 王新伟 on 2019/8/1.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZTToastView : UIView
/**优先使用的方法 默认时间是3.0s*/
+(void)showToast:(NSString *)toast;
/**自由设置toast消失时间*/
+(void)showToast:(NSString *)toast duration:(double)duration;
@end

NS_ASSUME_NONNULL_END
