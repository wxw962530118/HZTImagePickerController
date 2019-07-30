//
//  ToolBaseClass.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ToolBaseClass : NSObject
/**构建单利*/
+(instancetype)manager;
/**判断手机型号是否为iPhoneX及以上*/
-(BOOL)handleIPhoneModel;
/**计算字符串的宽度 */
+(CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font;
@end
/** Tool: 判断设备是否为 iPhoneX、iPhone XR、iPhone Xs、iPhone Xs Max*/
CG_INLINE BOOL IS_IPhoneX(){
    return [[ToolBaseClass manager] handleIPhoneModel];
};
NS_ASSUME_NONNULL_END
