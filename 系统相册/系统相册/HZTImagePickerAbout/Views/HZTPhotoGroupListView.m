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
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
/***/
@property (nonatomic, strong) NSMutableArray * groups;
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
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
}

#pragma mark --- 系统相册图片加载
- (void)setGroupWithAssetsFilter:(ALAssetsFilter *)assetsFilter{
    [self.groups removeAllObjects];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            /**选出资源 allVideos allAssets*/
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0){
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos){
                    [self.groups insertObject:group atIndex:0];
                } else if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupPhotoStream && self.groups.count > 0){
                    [self.groups insertObject:group atIndex:1];
                } else {
                    [self.groups addObject:group];
                }
            }
        } else {
            [self dataReload];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        /**没权限*/
        [self showNotAllowed];
    };
    
    //显示的相册
    NSUInteger type = ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream |
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}


-(void)showNotAllowed{
    NSLog(@"当前没有权限访问相册");
}

#pragma mark --- reloadData
- (void)dataReload{
    /**没有图片*/
    if (self.groups.count == 0) [self showNoAssets];
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
    cell.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self reloadData];
    ALAssetsGroup *group = [self.groups objectAtIndex:indexPath.row];
    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:isAnimation:)]) {
        [_my_delegate didSelectGroup:group isAnimation:!self.isFirstLoad];
    }
    self.isFirstLoad = NO;
}

#pragma mark - getter/setter
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
}

#pragma mark - ALAssetsLibrary
- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        static dispatch_once_t pred = 0;
        static ALAssetsLibrary *library = nil;
        dispatch_once(&pred, ^{
            library = [[ALAssetsLibrary alloc] init];
        });
        _assetsLibrary = library;
    }
    return _assetsLibrary;
}

@end
