//
//  HZTPhotoAlbumListCell.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZTAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HZTPhotoAlbumListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
/***/
@property (nonatomic, strong) HZTAssetModel * assetModel;
/***/
@property (nonatomic, copy) void (^selectedItemBlock)(HZTAssetModel * model);
/***/
@property (nonatomic, copy) NSString *representedAssetIdentifier;
/***/
@property (nonatomic, assign) int32_t imageRequestID;
@end

NS_ASSUME_NONNULL_END
