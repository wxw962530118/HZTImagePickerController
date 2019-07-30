//
//  HZTPhotoGroupCell.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
NS_ASSUME_NONNULL_BEGIN

@interface HZTPhotoGroupCell : UITableViewCell
/***/
@property (nonatomic, strong) ALAssetsGroup * assetsGroup;
@end

NS_ASSUME_NONNULL_END
