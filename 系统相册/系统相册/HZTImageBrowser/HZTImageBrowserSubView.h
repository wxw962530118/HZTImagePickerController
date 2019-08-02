//
//  HZTImageBrowserSubView.h
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HZTImageBrowserModel;

@protocol HZTImageBrowserSubViewDelegate <NSObject>
/* 单击 后的操作 */
- (void)imageBrowserSubViewSingleTapWithModel:(HZTImageBrowserModel *)imageBrowserModel;
/* 改变主视图 的 透明度 */
- (void)imageBrowserSubViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha;

@end

@interface HZTImageBrowserSubView : UIView

@property(nonatomic,weak)id<HZTImageBrowserSubViewDelegate> delegate;
/**
 初始化浏览的子视图
 @param frame  位置 大小
 @param imageBrowserModel  数据模型
 @return HZTImageBrowserSubView
 */
- (HZTImageBrowserSubView *)initWithFrame:(CGRect)frame ImageBrowserModel:(HZTImageBrowserModel *)imageBrowserModel;
/**外界滚动结束 后 更新某条数据*/
-(void)updateDataWithModel;
/**当前选中的idnex*/
@property (nonatomic, assign) NSInteger selectIndex;

@end
