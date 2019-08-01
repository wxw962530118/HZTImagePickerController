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
typedef NS_ENUM(NSInteger,PHAssetType){
    PHAssetType_Image = 0,  /**普通图片*/
    PHAssetType_Gif,        /**gif*/
    PHAssetType_Video,      /**视频*/
    PHAssetType_Audio,      /**音频*/
    PHAssetType_LivePhoto   /**现场照片*/
};

@interface HZTAssetModel : NSObject
/**/
@property (nonatomic, strong) UIImageView * imageView;
/***/
@property (nonatomic, strong) PHAsset * asset;
/**是否选中*/
@property (nonatomic, assign)BOOL isSelected;
/**视频的时长*/
@property (nonatomic, assign) double durationValue;
/**封面图*/
@property (nonatomic, strong) UIImage * coverImage;
/***/
@property (nonatomic, assign) PHAssetType assetType;
/***/
@property (nonatomic, copy) NSString * videoUrl;
/**选择图片时候带动画*/
@property (nonatomic, assign) BOOL isNotAnimation;
/**是否为拍照*/
@property (nonatomic, assign) BOOL isCameraRoll;
@end

NS_ASSUME_NONNULL_END
