//
//  HZTPhotoAlbumListCell.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoAlbumListCell.h"

@interface HZTPhotoAlbumListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end

@implementation HZTPhotoAlbumListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAssetModel:(HZTAssetModel *)assetModel{
    _assetModel = assetModel;
    self.coverImgView.image = assetModel.coverImage;
    [self.chooseBtn setImage:[UIImage imageNamed:assetModel.isSelected ? @"select_img_icon" : @"no_select_icon"] forState:UIControlStateNormal];
}

- (IBAction)chooseAction:(id)sender {
    if (self.selectedItemBlock) {
        self.selectedItemBlock(self.assetModel);
    }
}


@end
