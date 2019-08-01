//
//  HZTChooseFilesManager.m
//  jia
//
//  Created by 王新伟 on 2019/6/6.
//

#import "HZTChooseFilesManager.h"
#import "HZTImagePickerController.h"

@interface HZTChooseFilesManager ()<HZTImagePickerHeaderDelegate>
/***/
@property (nonatomic, assign) ChooseFilesType type;
/***/
@property (nonatomic, weak) UIViewController * currentVc;
/***/
@property (nonatomic, copy) void (^Block)(NSMutableArray<HZTUploadFileInfoModel *> * filesArr);
/**需要回调出去的结果*/
@property (nonatomic, strong) NSMutableArray <HZTUploadFileInfoModel *>* resultArray;
/***/
@property (nonatomic, strong) NSTimer * videoConverTimer;
/***/
@property (nonatomic, strong) AVAssetExportSession * currentAudioSession;
/***/
@property (nonatomic, assign) NSInteger maxFilesCount;
@end

static HZTChooseFilesManager * manager;

@implementation HZTChooseFilesManager

+(instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

-(void)chooseFilesWithType:(ChooseFilesType)type currentVc:(UIViewController *)currentVc currentFilesArr:(NSMutableArray <HZTUploadFileInfoModel *>*)currentFilesArr maxFilesCount:(NSInteger)maxFilesCount callBack:(void (^)(NSMutableArray<HZTUploadFileInfoModel *> * _Nonnull))callBack{
    self.type = type;
    self.maxFilesCount = maxFilesCount;
    self.currentVc = currentVc;
    self.Block = callBack;
    self.resultArray = currentFilesArr;
    [self handleOthers];
}

-(void)handleOthers{
    [self.currentVc.view endEditing:NO];
    if (self.type ==  ChooseFilesType_ICamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
        }
    }else if (self.type ==  ChooseFilesType_AlbumPhoto){
        HZTImagePickerController * vc = [[HZTImagePickerController alloc] initWithMaxCount:self.maxFilesCount - self.resultArray.count delegate:self];
        [self.currentVc presentViewController:vc animated:YES completion:NULL];

//        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxFilesCount - self.resultArray.count delegate:self];
//        picker.allowPickingVideo = NO;
//        picker.allowPickingImage = YES;
//        picker.allowTakePicture = NO;
//        picker.allowPickingOriginalPhoto = NO;
       // picker.sortAscendingByModificationDate = YES;
       // [self.currentVc presentViewController:picker animated:YES completion:NULL];
    }else if (self.type ==  ChooseFilesType_AlbumVideo){
        HZTImagePickerController * vc = [[HZTImagePickerController alloc] initWithMaxCount:self.maxFilesCount - self.resultArray.count delegate:self];
        [self.currentVc presentViewController:vc animated:YES completion:NULL];
//        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxFilesCount - self.resultArray.count delegate:self];
//        picker.allowPickingVideo = YES;
//        picker.allowPickingImage = NO;
//        picker.allowTakePicture = NO;
//        picker.allowTakeVideo = NO;
//        picker.allowPickingOriginalPhoto = NO;
//        picker.sortAscendingByModificationDate = YES;
//        picker.allowPickingMultipleVideo = YES;
//        [self.currentVc presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)configAudioWithData:(NSData *)mp3Data len:(int)len {
    //[self handleAudioWithData:mp3Data len:len];
}

- (void)configWithCameraInfo:(NSArray<NSDictionary *> *)files {
    //[self handleMediaFromCamera:files];
}

- (void)configWithPhotoLibrayPicInfo:(NSArray<UIImage *> *)photos assets:(NSArray *)assets {
    //[self handlePicsWithPhotos:photos assets:assets];
}

- (void)configWithPhotoLibrayVideoInfo:(id)asset {
    //[self handleVideoWithAsset:asset];
}

#pragma mark ---TZImagePickerControllerDelegate
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
//    if (photos.count == 0 || photos.count != assets.count) return;
//    [self handlePicsWithPhotos:photos assets:assets];
//}
//
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
//    [self handleVideoWithAsset:asset];
//}
//
//- (void)handleVideoAsset:(AVURLAsset *)videoAsset cover:(UIImage *)cover{
//    NSString * videoPath = videoAsset.URL.path;
//    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.currentVc.view animated:YES];
//    hud.labelText = @"视频转码中...";
//    [self outputVideo:videoPath completion:^(HZTUploadFileInfo *info) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.currentVc.view animated:YES];
//            if (!info) return;
//            [self.resultArray addObject:info];
//            if (self.Block) self.Block(self.resultArray);
//        });
//    }];
//}
//
//- (void)handleVideoWithAsset:(id)asset {
//    if (!asset) return;
//    if ([asset isKindOfClass:[PHAsset class]]) {
//        PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
//        options.version = PHVideoRequestOptionsVersionOriginal;
//        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
//        options.networkAccessAllowed = YES;
//        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.currentVc.view animated:YES];
//        hud.labelText = @"视频获取中...";
//        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
//            AVURLAsset * videoAsset = (AVURLAsset*)avasset;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.currentVc.view animated:YES];
//                if (!videoAsset) return;
//                [self handleVideoAsset:videoAsset cover:nil];
//            });
//        }];
//    }else if ([asset isKindOfClass:[ALAsset class]]) {
//        NSURL * videoURL = [asset valueForProperty:ALAssetPropertyAssetURL];
//        AVURLAsset * videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
//        [self handleVideoAsset:videoAsset cover:nil];
//    }
//}
//
//-(void)handlePicsWithPhotos:(NSArray<UIImage *> *)photos assets:(NSArray *)assets{
//    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.currentVc.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        for (NSInteger i = 0; i < assets.count; i++) {
//            PHAsset * asset = assets[i];
//            if (asset.mediaType == PHAssetMediaTypeVideo) {
//                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//                options.version = PHVideoRequestOptionsVersionOriginal;
//                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
//                options.networkAccessAllowed = YES;
//                hud.labelText = @"视频获取中...";
//                [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
//                    AVURLAsset *videoAsset = (AVURLAsset*)avasset;
//                    if (!videoAsset){
//                        dispatch_semaphore_signal(sema);
//                        return;
//                    }
//                    [self outputVideo:videoAsset.URL.path completion:^(HZTUploadFileInfo *info) {
//                        if (info) {
//                            [self.resultArray addObject:info];
//                        }
//                        dispatch_semaphore_signal(sema);
//                    }];
//                }];
//                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//            }else if (asset.mediaType == PHAssetMediaTypeImage) {
//                UIImage *img = photos[i];
//                HZTUploadFileInfo *file = [self packageImgInfo:img index:i];
//                [self.resultArray addObject:file];
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.currentVc.view animated:YES];
//            if (self.Block) self.Block(self.resultArray);
//        });
//    });
//}
//
//#pragma mark --- 自定义相机拍照回调
//- (void)clickedNextBtn:(NSArray *)arrFiles {
//    [self handleMediaFromCamera:arrFiles];
//}
//

#pragma mark --- 图片压缩及视频转码
//- (void)handleMediaFromCamera:(NSArray *)arrFiles {
//    if (arrFiles.count == 0) return;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.currentVc.view animated:YES];
//    hud.labelText = @"图片处理中...";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        for (NSInteger i = 0; i < arrFiles.count; i++) {
//            NSDictionary * dic = arrFiles[i];
//            NSString * type = dic[@"type"];
//            NSString * name = dic[@"name"];
//            NSString * path = [[MiscUtils getICameraDirectory] stringByAppendingPathComponent:name];
//            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) continue;
//            if ([type isEqualToString:@"i"]) {
//                UIImage * img = [UIImage imageWithContentsOfFile:path];
//                HZTUploadFileInfo * info = [self packageImgInfo:img index:i];
//                [self.resultArray addObject:info];
//                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//            }else if ([type isEqualToString:@"v"]) {
//                hud.labelText = @"视频处理中...";
//                [self outputVideo:path completion:^(HZTUploadFileInfo *info) {
//                    if (info) {
//                        [self.resultArray addObject:info];
//                    }
//                    dispatch_semaphore_signal(sema);
//                }];
//                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.currentVc.view animated:YES];
//            if (self.resultArray.count == 0) return;
//            if (self.Block) self.Block(self.resultArray);
//            if (_videoConverTimer) [self invalidateTimer];
//        });
//    });
//}
//
//- (HZTUploadFileInfo *)packageImgInfo:(UIImage *)img index:(NSInteger)idx{
//    NSString * fileDirectory = [HZTUploadFileInfo hztNoteFilePath];
//    CGFloat itemW = (kScreenW - 5*15)/4;
//    long long now = (long long)[[NSDate date] timeIntervalSince1970];
//    UIImage  * thumnailImg = [HZTImageCompressUtil redrawImage:img Width:itemW Height:itemW];
//    NSString * imgThumailFileName = [NSString stringWithFormat:@"%lld_%d_t.jpg", now, (int)idx];
//    NSString * imgFileName = [NSString stringWithFormat:@"%lld_%d.jpg", now, (int)idx];
//    [UIImageJPEGRepresentation(thumnailImg, 1.0) writeToFile:[fileDirectory stringByAppendingPathComponent:imgThumailFileName] atomically:NO];
//    [UIImageJPEGRepresentation(img, 1.0) writeToFile:[fileDirectory stringByAppendingPathComponent:imgFileName] atomically:NO];
//    HZTUploadFileInfo * file = [HZTUploadFileInfo new];
//    file.picWidth = img.size.width;
//    file.picHeight = img.size.height;
//    file.type = @"i";
//    file.oriFileName = imgFileName;
//    file.thumnailName = imgThumailFileName;
//    file.thumnailImage = thumnailImg;
//    return file;
//}
//
//- (void)outputVideo:(NSString *)path completion:(void(^)(HZTUploadFileInfo *info))block {
//    if (path.length == 0) return;
//    UIImage *img = [MiscUtils thumbnailImageForVideo:[NSURL fileURLWithPath:path] atTime:0];
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
//    AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ssS"];
//    NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
//    NSLog(@"video outputPath = %@",outputPath);
//    session.outputURL = [NSURL fileURLWithPath:outputPath];
//    session.shouldOptimizeForNetworkUse = true;
//    NSArray *supportedTypeArray = session.supportedFileTypes;
//    if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
//        session.outputFileType = AVFileTypeMPEG4;
//    }else if (supportedTypeArray.count == 0) {
//        NSLog(@"No supported file types 视频类型暂不支持导出");
//        return;
//    }else {
//        session.outputFileType = [supportedTypeArray objectAtIndex:0];
//    }
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    self.currentAudioSession = session;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.videoConverTimer) [self invalidateTimer];
//        self.videoConverTimer = [NSWeakTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateVideoConverProgress) userInfo:nil repeats:YES];
//    });
//    [session exportAsynchronouslyWithCompletionHandler:^(void) {
//        switch (session.status) {
//            case AVAssetExportSessionStatusUnknown:
//                NSLog(@"AVAssetExportSessionStatusUnknown"); break;
//            case AVAssetExportSessionStatusWaiting:
//                NSLog(@"AVAssetExportSessionStatusWaiting"); break;
//            case AVAssetExportSessionStatusExporting:
//                NSLog(@"AVAssetExportSessionStatusExporting"); break;
//            case AVAssetExportSessionStatusCompleted: {
//                NSLog(@"AVAssetExportSessionStatusCompleted");
//                CMTime time = [avAsset duration];
//                int duration = ceil(time.value/time.timescale);
//                CGFloat itemW = (kScreenW - 5*15)/4;
//                long long now = (long long)([[NSDate date] timeIntervalSince1970]*1000);
//                NSString *fileDir = [HZTUploadFileInfo hztNoteFilePath];
//                NSString *fileName = [NSString stringWithFormat:@"%lld.mp4", now];
//                NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
//                [[NSFileManager defaultManager] moveItemAtPath:outputPath toPath:filePath error:nil];
//                NSString *thumnailCoverName = [NSString stringWithFormat:@"%lld_t.jpg", now];
//                UIImage *thumnailImg = [HZTImageCompressUtil redrawImage:img Width:itemW Height:itemW];
//                [UIImageJPEGRepresentation(thumnailImg, 1.0) writeToFile:[fileDir stringByAppendingPathComponent:thumnailCoverName] atomically:NO];
//                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//                HZTUploadFileInfo *file = [HZTUploadFileInfo new];
//                file.picWidth = img.size.width;
//                file.picHeight = img.size.height;
//                file.type = @"v";
//                file.oriFileName = fileName;
//                file.thumnailName = thumnailCoverName;
//                file.thumnailImage = thumnailImg;
//                file.len = duration * 1000;
//                if (block) block(file);
//            }  break;
//            case AVAssetExportSessionStatusFailed: {
//                if (block)  block(nil);
//            } break;
//            default: break;
//        }
//    }];
//}
//
//- (void)updateVideoConverProgress {
//    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.currentVc.view];
//    if (!hud || !self.currentAudioSession) return;
//    int persent = self.currentAudioSession.progress * 100;
//    if (persent == 0) {
//        hud.labelText = @"视频转码中...";
//    }else {
//        hud.labelText = [NSString stringWithFormat:@"视频转码中 %d%@", persent, @"%"];
//    }
//    if (self.currentAudioSession.progress == 1 && self.videoConverTimer) {
//        [self invalidateTimer];
//    }
//}

#pragma mark --- 重置Timer
-(void)invalidateTimer{
    [self.videoConverTimer invalidate];
    self.videoConverTimer = nil;
    self.currentAudioSession = nil;
}

-(NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

@end
