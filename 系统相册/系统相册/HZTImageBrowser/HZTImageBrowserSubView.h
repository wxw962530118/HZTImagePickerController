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

- (HZTImageBrowserSubView *)initWithFrame:(CGRect)frame ImageBrowserModel:(HZTImageBrowserModel *)imageBrowserModel;
-(void)congifModel;
/***/
@property (nonatomic, assign) NSInteger selectIndex;

@end
