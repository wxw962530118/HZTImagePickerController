//
//  HZTPhotoGroupCell.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoGroupCell.h"
#import "HZTImageManager.h"
@interface HZTPhotoGroupCell ()
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCntLabel;
@end

@implementation HZTPhotoGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(HZTPhotoGroupModel *)model{
    _model = model;
    [[HZTImageManager manager] getPhotoWithAsset:model.result.lastObject completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
         self.groupImageView.image = photo;
    }];
    self.groupNameLabel.text = model.name;
    self.photoCntLabel.text = [NSString stringWithFormat:@"(%ld)",model.count];
}

@end
