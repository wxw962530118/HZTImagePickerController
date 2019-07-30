//
//  HZTImageManager.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTImageManager.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
@implementation HZTImageManager

CGSize AssetGridThumbnailSize;
CGFloat HZTScreenScale;

+ (instancetype)manager {
    static HZTImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.photoPreviewMaxWidth = 600;
    }
    return self;
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    [self configTZScreenWidth];
    _columnNumber = columnNumber;
    CGFloat margin = 4;
    CGFloat itemWH = (kScreenW - 2 * margin - 4) / columnNumber - margin;
    AssetGridThumbnailSize = CGSizeMake(itemWH * HZTScreenScale, itemWH * HZTScreenScale);
}

- (void)configTZScreenWidth {
    /**如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成2.0*/
    HZTScreenScale = 2.0;
    if (kScreenW > 700) {
        HZTScreenScale = 1.5;
    }
}

/**获取封面图*/
- (PHImageRequestID)getPostImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *))completion {
    return [[HZTImageManager manager] getPhotoWithAsset:asset photoWidth:40 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion) completion(photo);
    }];
}

/**获得照片本身*/
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion {
    CGFloat fullScreenWidth = kScreenW;
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    return [self getPhotoWithAsset:asset photoWidth:photoWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    CGSize imageSize;
    if (photoWidth < kScreenW && photoWidth < _photoPreviewMaxWidth) {
        imageSize = AssetGridThumbnailSize;
    } else {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat pixelWidth = photoWidth * 1.5 * 1.5;
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5;
        }
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }
    
    __block UIImage *image;
    // 修复获取图片时出现的瞬间内存过高问题
    // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            image = result;
        }
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            //result = [self fixOrientation:result];
            if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressHandler) {
                        progressHandler(progress, error, stop, info);
                    }
                });
            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData];
//                if (![TZImagePickerConfig sharedInstance].notScaleImage) {
//                    resultImage = [self scaleImage:resultImage toSize:imageSize];
//                }
                if (!resultImage) {
                    resultImage = image;
                }
                //resultImage = [self fixOrientation:resultImage];
                if (completion) completion(resultImage,info,NO);
            }];
        }
    }];
    return imageRequestID;
}

@end
