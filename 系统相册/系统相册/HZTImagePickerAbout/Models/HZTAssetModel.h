//
//  HZTAssetModel.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,AssetType){
    AssetType_Image = 0,
    AssetType_Video
};

@interface HZTAssetModel : NSObject
/***/
@property (nonatomic, strong) PHAsset * asset;
/**是否选中*/
@property (nonatomic, assign)BOOL isSelected;
/**视频的时长*/
@property (nonatomic, assign) double durationValue;
/**封面图*/
@property (nonatomic, strong) UIImage * coverImage;
/***/
@property (nonatomic, assign) AssetType type;
/***/
@property (nonatomic, copy) NSString * videoUrl;
/**选择图片时候带动画*/
@property (nonatomic, assign) BOOL isNotAnimation;
/**是否为拍照*/
@property (nonatomic, assign) BOOL isCameraRoll;
@end

NS_ASSUME_NONNULL_END
