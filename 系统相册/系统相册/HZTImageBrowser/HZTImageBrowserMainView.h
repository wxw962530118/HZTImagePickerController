//
//  HZTImageBrowserMainView.h
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HZTImageBrowserModel;

@protocol HZTImageBrowserMainViewDelegate <NSObject>
/* 单击 后的操作 */
- (void)imageBrowserMianViewSingleTapWithModel:(HZTImageBrowserModel *)imageBrowserModel;
/* 改变主视图 的 透明度 */
- (void)imageBrowserMainViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha;

@end

@interface HZTImageBrowserMainView : UIView
@property(nonatomic,weak)id<HZTImageBrowserMainViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,assign)NSInteger selectPage;
/**
 初始化主视图
 @param browserModels 大图的下载地址
 @param originImageViews 原始的小图的 iamgeView
 @param selectPage 当前选中的是哪一个iamgeView
 @return 主视图
 */
+ (instancetype)imageBrowserMainViewUrlStr:(NSArray<HZTImageBrowserModel *>*)browserModels originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage isFromPicker:(BOOL)isFromPicker;
/**隐藏子组件
 @param isHidden 是否隐藏
 */
- (void)subViewHidden:(BOOL)isHidden;
@end
