//
//  HZTPhotoGroupModel.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/31.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface HZTPhotoGroupModel : NSObject
/**相册的名字*/
@property (nonatomic, strong) NSString *name;
/**相册的个数或者相机胶卷资源的个数*/
@property (nonatomic, assign) NSInteger count;
/**PHFetchResult<PHAsset *>请求回来的相册*/
@property (nonatomic, strong) PHFetchResult<PHAsset *> *result;
@end

NS_ASSUME_NONNULL_END
