//
//  HZTChooseFilesManager.h
//  jia
//
//  Created by 王新伟 on 2019/6/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HZTUploadFileInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ChooseFilesType){
    ChooseFilesType_ICamera,    /**自定义相机<拍照片/录制视频>*/
    ChooseFilesType_AlbumPhoto, /**从相册选择照片*/
    ChooseFilesType_AlbumVideo, /**从相册选视频*/
    ChooseFilesType_RecordAudio /**录制音频*/
};

@interface HZTChooseFilesManager : NSObject
+ (instancetype)manager;
/**
 直接从相册选择图片/视频/录制拍照
 @param type      当前是以哪种方式添加媒体文件
 @param currentVc 当前调用的控住器 <用来一些present及MB提示的展示>
 @param currentFilesArr 当前已经添加的媒体文件数组
 @param callBack  选择媒体文件 完成回调到控制器<构建HZTChooseFilesManager的地方 TODO...refresh>
 */
-(void)chooseFilesWithType:(ChooseFilesType)type currentVc:(UIViewController *)currentVc currentFilesArr:(NSMutableArray <HZTUploadFileInfoModel *>*)currentFilesArr maxFilesCount:(NSInteger)maxFilesCount callBack:(void (^)(NSMutableArray <HZTUploadFileInfoModel *>* filesArr))callBack;
/**首页发布随手记->直接录音 完成进入发布页*/
- (void)configAudioWithData:(NSData *)mp3Data len:(int)len;
/**首页发布随手记->直接拍照完成进入发布页*/
- (void)configWithCameraInfo:(NSArray<NSDictionary *> *)files;
/**首页发布随手记->直接从相册选取照片完成进入发布页*/
- (void)configWithPhotoLibrayPicInfo:(NSArray<UIImage *> *)photos assets:(NSArray *)assets;
/**首页发布随手记->直接从相册选取视频完成进入发布页*/
- (void)configWithPhotoLibrayVideoInfo:(id)asset;
@end

NS_ASSUME_NONNULL_END
