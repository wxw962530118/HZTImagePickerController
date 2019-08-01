//
//  HZTPhotoAlbumListCell.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoAlbumListCell.h"
#import "HZTImageManager.h"
#import "HZTGradientView.h"
@interface HZTPhotoAlbumListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *asyncProgressLabel;
@property (nonatomic, assign) int32_t bigImageRequestID;
@end

@implementation HZTPhotoAlbumListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.asyncProgressLabel.hidden = YES;
    self.gradientView.hidden = YES;
}

-(void)setAssetModel:(HZTAssetModel *)assetModel{
    _assetModel = assetModel;
    self.representedAssetIdentifier = assetModel.asset.localIdentifier;
    int32_t imageRequestID = [[HZTImageManager manager] getPhotoWithAsset:assetModel.asset photoWidth:40 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if ([self.representedAssetIdentifier isEqualToString:assetModel.asset.localIdentifier]) {
            self.coverImgView.image = photo;
        }else{
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) self.imageRequestID = 0;
    } progressHandler:nil networkAccessAllowed:NO];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
    [self.chooseBtn setImage:[UIImage imageNamed:assetModel.isSelected ? @"select_img_icon" : @"no_select_icon"] forState:UIControlStateNormal];
}

- (IBAction)chooseAction:(id)sender {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = NO;
    [[PHImageManager defaultManager] requestImageDataForAsset:self.assetModel.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
            /**图片在icloud 需要同步*/
            [self asyncPhotoFromiCloud];
        }else{
            if (self.selectedItemBlock) self.selectedItemBlock(self.assetModel);
        }
    }];
}

- (void)asyncPhotoFromiCloud {
    if (_bigImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
    }
    _bigImageRequestID = [[HZTImageManager manager] requestImageDataForAsset:self.assetModel.asset completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        self.asyncProgressLabel.hidden = YES;
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (error) {
            NSLog(@"async iCloud error:%@",error.userInfo);
            self.chooseBtn.hidden = NO;
            self.asyncProgressLabel.hidden = YES;
        }else{
            progress = progress > 0.02 ? progress : 0.02;
            NSNumber * num = [NSNumber numberWithDouble:progress * 100];
            self.asyncProgressLabel.text = [NSString stringWithFormat:@"同步iColud%d%@",[num intValue],@"%"];
            self.asyncProgressLabel.hidden = [num intValue] >= 100;
            self.chooseBtn.hidden = !self.asyncProgressLabel.hidden;
            NSLog(@"downLoad from iCloud Progress:%.2f  present:%d",progress,[num intValue]);
        }
    }];
}

- (void)cancelBigImageRequest {
    if (_bigImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
    }
    self.asyncProgressLabel.hidden = YES;
}

@end
