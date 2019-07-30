//
//  HZTPhotoGroupListController.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
NS_ASSUME_NONNULL_BEGIN

@interface HZTPhotoGroupListController : UIViewController
/**资源过滤*/
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@end

NS_ASSUME_NONNULL_END
