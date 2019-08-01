//
//  HZTAssetModel.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTAssetModel.h"

@implementation HZTAssetModel

-(PHAssetType)assetType{
    PHAssetType type = PHAssetType_Image;
    if (self.asset.mediaType == PHAssetMediaTypeVideo)      type = PHAssetType_Video;
    else if (self.asset.mediaType == PHAssetMediaTypeAudio) type = PHAssetType_Audio;
    else if (self.asset.mediaType == PHAssetMediaTypeImage) {
        if (@available(iOS 9.1, *)) {
            if (self.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) type = PHAssetType_LivePhoto;
        }
        if ([[self.asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = PHAssetType_Gif;
        }
    }
    return type;
}

-(double)durationValue{
    return self.assetType == PHAssetType_Video ? self.asset.duration : 0.0;
}

@end
