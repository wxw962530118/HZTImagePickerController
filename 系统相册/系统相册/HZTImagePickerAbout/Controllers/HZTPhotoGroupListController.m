//
//  HZTPhotoGroupListController.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoGroupListController.h"
#import "HZTPhotoAlbumListController.h"
#import "HZTPhotoGroupListView.h"
@interface HZTPhotoGroupListController ()<HZTPhotoGroupViewDelegate,HZTPhotoPickerDelegate>
/***/
@property (nonatomic, strong) HZTPhotoGroupListView * groupListView;
@end

@implementation HZTPhotoGroupListController

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"照片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelCallBack)];
    [self addGroupListView];
}

-(void)addGroupListView{
    if (!_groupListView) {
        _groupListView = [[HZTPhotoGroupListView alloc] initWithFrame:self.view.frame];
        _groupListView.my_delegate = self;
        [_groupListView setGroupWithAssetsFilter:[ALAssetsFilter allAssets]];
        [self.view addSubview:_groupListView];
    }
}

-(void)cancelCallBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 具体相册分组选择回调
-(void)didSelectGroup:(ALAssetsGroup *)assetsGroup isAnimation:(BOOL)isAnimation{
    HZTPhotoAlbumListController * vc = [HZTPhotoAlbumListController new];
    vc.isTopFilter = NO;
    vc.assetsGroup = assetsGroup;
    vc.assetsFilter = [ALAssetsFilter allPhotos];
    vc.m_delegate = self;
    vc.multipleSelection = true;
    vc.rowCount = 4;
    vc.maximumNumberOfSelection = 5;
    [self.navigationController pushViewController:vc animated:isAnimation];
}

-(void)dealloc{
    NSLog(@"控制器:%@ %@ 被释放",NSStringFromClass([self class]),self.navigationItem.title);
}

@end
