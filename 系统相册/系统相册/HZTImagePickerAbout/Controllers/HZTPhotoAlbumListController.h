//
//  HZTPhotoAlbumListController.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZTAssetModel.h"
#import "HZTPhotoGroupModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HZTPhotoAlbumListController;
@protocol HZTPhotoPickerDelegate <NSObject>
@optional
/**选择完成*/
- (void)photoPicker:(HZTPhotoAlbumListController *)picker didSelectAssets:(NSArray <HZTAssetModel *>*)assets;
/**点击选中*/
- (void)photoPicker:(HZTPhotoAlbumListController *)picker didSelectAsset:(HZTAssetModel *)asset;
/**取消选中*/
- (void)photoPicker:(HZTPhotoAlbumListController *)picker didDeselectAsset:(HZTAssetModel *)asset;
/**点击相机按钮相关操作*/
- (void)photoPickerTapCameraAction:(HZTPhotoAlbumListController *)picker;
/**取消*/
- (void)photoPickerDidCancel:(HZTPhotoAlbumListController *)picker;
/**选择过滤*/
- (void)photoPickerDidSelectionFilter:(HZTPhotoAlbumListController *)picker;
@end
@interface HZTPhotoAlbumListController : UIViewController
/**照片筛选在顶部 Default is NO*/
@property (nonatomic, assign) BOOL isTopFilter;
/**从相册分组列表带过来的HZTPhotoGroupModel对象*/
@property (nonatomic, strong) HZTPhotoGroupModel * groupModel;
/***strong 修饰 处理 delegate 为nil的问题*/
@property (strong, nonatomic) id<HZTPhotoPickerDelegate> m_delegate;
/**选中的项 里面是自定义的HZTAssetModel 对象*/
@property (nonatomic, strong) NSMutableArray <HZTAssetModel *>* selectedItems;
/**是否开启多选 Default is NO*/
@property (nonatomic, assign) BOOL multipleSelection;
/**每行显示的Item个数 Default is 4*/
@property (nonatomic, assign) NSInteger rowCount;
/**是否选择视频 Default is NO*/
@property (nonatomic, assign) BOOL isChooseVideo;
/**是否选择图片 Default is YES*/
@property (nonatomic, assign) BOOL isChoosePhoto;
/**最多选择项 Default is 9*/
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
/**最少选择项 Default is 1*/
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;
@end

NS_ASSUME_NONNULL_END
