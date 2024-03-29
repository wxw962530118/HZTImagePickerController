//
//  HZTImageManager.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZTAssetModel.h"
#import "HZTPhotoGroupModel.h"
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface HZTImageManager : NSObject
/**处理数据相关*/
+ (instancetype)manager;
/**默认4列, TZPhotoPickerController中的照片collectionView*/
@property (nonatomic, assign) NSInteger columnNumber;
/**Default is 600px / 默认600像素宽*/
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
/**对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前*/
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;
/**获得照片*/
- (PHImageRequestID)getPostImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *postImage))completion;
/**所有的相册,包括用户创建,系统创建等,得到PHAsset对象 转换成HZTPhotoGroupModel*/
- (void)getAllAlbumsContentImage:(BOOL)contentImage contentVideo:(BOOL)contentVideo completion:(void (^)(NSArray<HZTPhotoGroupModel *> *fetchResults))completion;
/**获得原图*/
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;
/**获得照片 从iCloud*/
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(nullable void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
/***/
- (PHImageRequestID)requestImageDataForAsset:(PHAsset *)asset completion:(nullable void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion progressHandler:(nullable void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;
@end

NS_ASSUME_NONNULL_END
