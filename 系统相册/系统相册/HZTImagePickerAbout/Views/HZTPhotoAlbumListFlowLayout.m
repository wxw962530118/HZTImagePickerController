//
//  HZTPhotoAlbumListFlowLayout.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoAlbumListFlowLayout.h"

@interface HZTPhotoAlbumListFlowLayout ()
/***/
@property (nonatomic, assign) ListFlowLayoutType layoutType;
@end

@implementation HZTPhotoAlbumListFlowLayout
-(instancetype)initWithLayoutType:(ListFlowLayoutType)layoutType{
    if (self = [super init]) {
        self.layoutType = layoutType;
    }
    return self;
}

-(void)setLayoutType:(ListFlowLayoutType)layoutType{
    _layoutType = layoutType;
}
@end
