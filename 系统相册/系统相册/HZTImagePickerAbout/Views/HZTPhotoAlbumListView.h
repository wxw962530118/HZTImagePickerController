//
//  HZTPhotoAlbumListView.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZTPhotoAlbumListFlowLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface HZTPhotoAlbumListView : UICollectionView
- (instancetype)initWithFrame:(CGRect)frame layoutType:(ListFlowLayoutType)layoutType;
@end

NS_ASSUME_NONNULL_END
