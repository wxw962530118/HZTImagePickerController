//
//  HZTPhotoGroupListView.h
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HZTPhotoGroupModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HZTPhotoGroupViewDelegate <NSObject>
/**选中系统相册分组*/
- (void)didSelectGroup:(HZTPhotoGroupModel *)groupModel isAnimation:(BOOL)isAnimation;
@end
/**分组的列表*/
@interface HZTPhotoGroupListView : UITableView
@property (weak, nonatomic) id<HZTPhotoGroupViewDelegate> my_delegate;
/**选中相册的索引*/
@property (nonatomic) NSInteger selectIndex;
/***/
@property (nonatomic, strong) NSArray <HZTPhotoGroupModel *>* fetchResults;
@end

NS_ASSUME_NONNULL_END
