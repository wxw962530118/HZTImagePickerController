//
//  HZTImageBrowserTranslation.h
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HZTImageBrowserMainView;

@interface HZTImageBrowserTranslation : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign)BOOL isBrowserMainView;
@property(nonatomic,strong)HZTImageBrowserMainView * mainBrowserMainView;
@property(nonatomic,strong)UIView * browserControllerView;

@end
