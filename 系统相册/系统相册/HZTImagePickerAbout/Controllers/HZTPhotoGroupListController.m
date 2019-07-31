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
#import "HZTImageManager.h"
#import <Photos/Photos.h>
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
    [[HZTImageManager manager] getAllAlbumsContentImage:YES contentVideo:YES completion:^(NSArray<HZTPhotoGroupModel *> *fetchResults) {
        self.groupListView.fetchResults = fetchResults;
        [self.groupListView reloadData];
    }];
}

-(HZTPhotoGroupListView *)groupListView{
    if (!_groupListView) {
        _groupListView = [[HZTPhotoGroupListView alloc] initWithFrame:self.view.frame];
        _groupListView.my_delegate = self;
        [self.view addSubview:_groupListView];
    }
    return _groupListView;
}

-(void)cancelCallBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 具体相册分组选择回调
-(void)didSelectGroup:(HZTPhotoGroupModel *)groupModel isAnimation:(BOOL)isAnimation{
    HZTPhotoAlbumListController * vc = [HZTPhotoAlbumListController new];
    vc.isTopFilter = NO;
    vc.groupModel = groupModel;
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
