//
//  HZTMacroNotifications.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HZTMacroNotifications : NSObject

@end

CG_INLINE void NotificationRegister(NSString *name, id observer, SEL selector, id object) {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

CG_INLINE void NotificationPost(NSString *name, id object, NSDictionary *userInfo) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

CG_INLINE void NotificationRemove(NSString *name, id observer, id object) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
}

CG_INLINE void NotificationRemoveAll(id observer) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

/* 通知类型 */
/**
 通知: 相册列表及相册预览页面点击完成*/
UIKIT_EXTERN NSString *const HZTNOTIFICATION_CHOOSE_PHOTH_COMPLETED;

NS_ASSUME_NONNULL_END
