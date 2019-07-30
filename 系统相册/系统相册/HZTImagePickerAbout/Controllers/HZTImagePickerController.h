//
//  HZTImagePickerController.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZTAssetModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HZTImagePickerController;
@protocol HZTImagePickerDelegate <NSObject>
@optional
/**选择完成*/
- (void)photoPicker:(HZTImagePickerController *)picker didSelectAssets:(NSArray <HZTAssetModel *>*)assets;
@end

@interface HZTImagePickerController : UINavigationController
/**导航栏配置样式相关*/

/**初始化方法*/
-(instancetype)initWithMaxCount:(NSInteger)maxCount delegate:(id<HZTImagePickerDelegate>)deleagte;

/**基础属性配置*/
/**最大选择图片数量  默认9张*/
@property (nonatomic, assign) NSInteger maxCount;

@end

NS_ASSUME_NONNULL_END
