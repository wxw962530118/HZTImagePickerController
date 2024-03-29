//
//  HZTImageBrowserManger.h
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HZTImageBrowserModel.h"
typedef void(^ForceTouchActionBlock)(NSInteger selectIndex, NSString *title);

@interface HZTImageBrowserManger : NSObject
/**选中哪一个imageView*/
@property(nonatomic,assign)NSInteger selectPage;
/**
 初始化 MHZTImageBrowserMangeranger
 @param browserModels 各个图片大图的url
 @param originImageViews 原始的小图
 @param controller 小图所在的视图控制器
 */
+ (HZTImageBrowserManger *)imageBrowserMangerWithUrlStr:(NSArray<HZTImageBrowserModel *>*)browserModels originImageViews:(NSArray<UIImageView *>*)originImageViews originController:(UIViewController *)controller isFromPicker:(BOOL)isFromPicker;
/**
 初始化 MHZTImageBrowserMangeranger
 @param browserModels 各个图片大图的url
 @param originImageViews 原始的小图
 @param controller 小图所在的视图控制器
 @param forceTouchCapability 是否开启3Dtouch
 @param titles 3Dtouch 上滑事件的title，可为 nil
 @param forceTouchActionBlock 设置的3Dtouch 上滑事件的的回调，可为 nil
 @return manger
 */
+ (HZTImageBrowserManger *)imageBrowserMangerWithUrlStr:(NSArray<HZTImageBrowserModel *>*)browserModels originImageViews:(NSArray<UIImageView *>*)originImageViews originController:(UIViewController *)controller isFromPicker:(BOOL)isFromPicker forceTouch:(BOOL)forceTouchCapability forceTouchActionTitles:(nullable NSArray <NSString *>*)titles forceTouchActionComplete:(nullable ForceTouchActionBlock)forceTouchActionBlock;
/**用户点击小图，进入图片查看大图*/
- (void)showImageBrowser;
@end
