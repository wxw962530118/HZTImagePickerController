//
//  HZTPhotoGroupListView.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoGroupListView.h"
#import "HZTPhotoGroupCell.h"
#import "HZTPhotoAlbumListController.h"
@interface HZTPhotoGroupListView()<UITableViewDataSource,UITableViewDelegate>
/***/
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation HZTPhotoGroupListView

- (instancetype)init {
    if (self = [super init]) {
        [self configInfo];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configInfo];
    }
    return self;
}

- (void)configInfo {
    self.isFirstLoad = YES;
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"HZTPhotoGroupCell" bundle:nil] forCellReuseIdentifier:@"HZTPhotoGroupCell"];
}

#pragma mark --- 系统分组相册图片加载
-(void)setFetchResults:(NSArray<HZTPhotoGroupModel *> *)fetchResults{
    _fetchResults = fetchResults;
    [self dataReload];
}

-(void)showNotAllowed{
    NSLog(@"当前没有权限访问相册");
}

#pragma mark --- reloadData
- (void)dataReload{
    /**没有图片*/
    if (self.fetchResults.count == 0) [self showNoAssets];
    /**默认选中第一组*/
    [self tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self reloadData];
}

- (void)showNoAssets {
    NSLog(@"%s",__func__);
}

#pragma mark - uitableviewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZTPhotoGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HZTPhotoGroupCell"];
    cell.model = self.fetchResults[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self reloadData];
    HZTPhotoGroupModel * model = [self.fetchResults objectAtIndex:indexPath.row];
    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:isAnimation:)]) {
        [_my_delegate didSelectGroup:model isAnimation:!self.isFirstLoad];
    }
    self.isFirstLoad = NO;
}

@end
