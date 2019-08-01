//
//  HZTGradientView.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/31.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZTGradientView : UIView
- (void)setupCAGradientLayer:(NSArray *)colors locations:(NSArray *)locations;
@end

NS_ASSUME_NONNULL_END
