//
//  HZTPhotoGroupCell.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoGroupCell.h"

@interface HZTPhotoGroupCell ()
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCntLabel;
@end

@implementation HZTPhotoGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setAssetsGroup:(ALAssetsGroup *)assetsGroup{
    _assetsGroup = assetsGroup;
    CGImageRef posterImage = assetsGroup.posterImage;
    size_t height = CGImageGetHeight(posterImage);
    float scale = height / 78.0f;
    self.groupImageView.image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.groupNameLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.photoCntLabel.text = [NSString stringWithFormat:@"(%ld)",(long)[assetsGroup numberOfAssets]];
}
@end
