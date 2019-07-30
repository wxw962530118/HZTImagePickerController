//
//  HZTPhotoAlbumListView.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoAlbumListView.h"
#import "HZTPhotoAlbumListCell.h"
#import "HZTPhotoAlbumListFlowLayout.h"

@interface HZTPhotoAlbumListView ()
/***/
@property (nonatomic, strong) HZTPhotoAlbumListFlowLayout * flowLayout;
@end

@implementation HZTPhotoAlbumListView

- (instancetype)initWithFrame:(CGRect)frame layoutType:(ListFlowLayoutType)layoutType{
    HZTPhotoAlbumListFlowLayout * flowLayout = [[HZTPhotoAlbumListFlowLayout alloc] initWithLayoutType:layoutType];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [[HZTPhotoAlbumListView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"HZTPhotoAlbumListCell" bundle:nil] forCellWithReuseIdentifier:@"HZTPhotoAlbumListCell"];
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
