//
//  HZTPhotoAlbumListFlowLayout.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ListFlowLayoutType){
    ListFlowLayoutType_Normal = 0,   /**普通的*/
    ListFlowLayoutType_WaterFlow     /**瀑布流*/
};

@interface HZTPhotoAlbumListFlowLayout : UICollectionViewFlowLayout
/**
  构建布局类
 @param layoutType 布局类型
 */
-(instancetype)initWithLayoutType:(ListFlowLayoutType)layoutType;
@end

NS_ASSUME_NONNULL_END
