//
//  HZTPhotoAlbumListController.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTPhotoAlbumListController.h"
#import "HZTPhotoAlbumListView.h"
#import "HZTPhotoAlbumListController.h"
#import "HZTPhotoAlbumListCell.h"
#import "HZTPhotoGroupListView.h"
#import "HZTMacroNotifications.h"
#import "ToolBaseClass.h"
#import <Photos/Photos.h>
#import "HZTImageManager.h"
@interface HZTPhotoAlbumListController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HZTPhotoGroupViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) id<UIGestureRecognizerDelegate> originalDelegate;
/***/
@property (nonatomic, strong) HZTPhotoAlbumListView * listView;
/***/
@property (nonatomic, strong) HZTPhotoGroupListView * groupListView;
/***/
@property (strong, nonatomic) NSMutableArray <HZTAssetModel *>* listDataArray;
/**完成按钮*/
@property (nonatomic, strong) UIButton * completeBtn;
/**预览按钮*/
@property (nonatomic, strong) UIButton * previewBtn;
/***/
@property (nonatomic, strong) NSMutableArray <HZTAssetModel *>* selectedArray;
/***/
@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;
@end

@implementation HZTPhotoAlbumListController

/**导致侧滑失效的设置
 -navigationBarHidden
 -navigationItem.hidesBackButton
 -navigationItem.leftBarButtonItem/leftBarButtonItems
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.originalDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.originalDelegate;
    self.originalDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavItem];
    [self addBottomToolView];
}

-(void)configNavItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dissMiss)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dissMiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addBottomToolView{
    if (!_completeBtn) {
        CGFloat toolHeight = IS_IPhoneX() ? 68 : 34;
        UIView * toolView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -toolHeight,[UIScreen mainScreen].bounds.size.width , toolHeight)];
        toolView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:toolView];
        _completeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_completeBtn addTarget:self action:@selector(clickCompleted) forControlEvents:UIControlEventTouchUpInside];
        _completeBtn.backgroundColor = [UIColor orangeColor];
        _completeBtn.layer.cornerRadius = 3;
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        CGFloat btnW = 55;
        _completeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - btnW - 10, 10,btnW,30);
        _completeBtn.enabled = NO;
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toolView addSubview:_completeBtn];
        
        _previewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_previewBtn addTarget:self action:@selector(clickPreview) forControlEvents:UIControlEventTouchUpInside];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _previewBtn.frame = CGRectMake(10, 10,35, 30);
        _previewBtn.enabled = NO;
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toolView addSubview:_previewBtn];
    }
}

-(void)setRowCount:(NSInteger)rowCount{
    _rowCount = rowCount;
    [HZTImageManager manager].columnNumber = rowCount;
}

-(HZTPhotoAlbumListView *)listView{
    if (!_listView){
        CGFloat toolHeight = IS_IPhoneX() ? 68 : 34;
        _listView = [[HZTPhotoAlbumListView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-toolHeight) layoutType:ListFlowLayoutType_Normal];
        _listView.dataSource = self;
        _listView.delegate = self;
        [self.view addSubview:_listView];
    }
    return _listView;
}

-(HZTPhotoGroupListView *)groupListView{
    if (!_groupListView) {
        _groupListView = [[HZTPhotoGroupListView alloc] init];
        _groupListView.my_delegate = self;
        [self.view addSubview:_groupListView];
    }
    return _groupListView;
}

-(NSMutableArray *)listDataArray{
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
    }
    return _listDataArray;
}

-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, ([UIScreen mainScreen].bounds.size.height - 100) /2, 100, 100);
        [[UIApplication sharedApplication].delegate.window addSubview:_indicatorView];
    }
    return _indicatorView;
}

-(void)setAssetsFilter:(ALAssetsFilter *)assetsFilter{
    _assetsFilter = assetsFilter;
    if (self.isTopFilter) {
        [self.groupListView setGroupWithAssetsFilter:assetsFilter];
    }else{
        [self didSelectGroup:self.assetsGroup];
    }
}

#pragma mark --- 选中分组 本地相册
- (void)didSelectGroup:(ALAssetsGroup *)assetsGroup {
    [self.indicatorView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadAssets:assetsGroup];
    });
}

/**判断是否是相机胶卷*/
- (BOOL)isCameraRollAlbum:(NSString *)albumName{
    return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"];
}

#pragma mark --- 从系统相册加载图片
- (void)loadAssets:(ALAssetsGroup *)assetsGroup {
    __weak typeof(self) weakSelf = self;
    [self.selectedItems removeAllObjects];
    [self.listDataArray removeAllObjects];
    PHFetchOptions * option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums){
        if (![collection isKindOfClass:[PHAssetCollection class]]){
            /**有可能是PHCollectionList类的的对象，过滤掉*/
            continue;
        }
        if ([self isCameraRollAlbum:collection.localizedTitle]){
            /**测试数据*/
            PHFetchResult<PHAsset *> * fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            NSLog(@"PHFetchResult:%@",fetchResult);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [fetchResult enumerateObjectsUsingBlock:^(PHAsset * asset, NSUInteger idx, BOOL *_Nonnull stop) {
                    HZTAssetModel * model = [[HZTAssetModel alloc] init];
                    model.asset = asset;
                    model.isSelected = false;
                    model.isCameraRoll = false;
                    [weakSelf.listDataArray addObject:model];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.indicatorView stopAnimating];
                    [weakSelf.listView reloadData];
                    [weakSelf.listView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                    weakSelf.navigationItem.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
                });
            });
        }
    }
}

#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    HZTPhotoAlbumListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HZTPhotoAlbumListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    cell.assetModel = self.listDataArray[indexPath.row];
    cell.selectedItemBlock = ^(HZTAssetModel *asset) {
        [weakSelf.selectedArray removeAllObjects];
        weakSelf.listDataArray[indexPath.row].isSelected = !self.listDataArray[indexPath.row].isSelected;
        for (HZTAssetModel * model in weakSelf.listDataArray) {
            if (model.isSelected) {
                [weakSelf.selectedArray addObject:model];
                weakSelf.completeBtn.enabled = YES;
            }else{
                if ([weakSelf.selectedArray containsObject:model]) {
                    [weakSelf.selectedArray removeObject:model];
                }
                if (self.selectedArray.count == 0) {
                    weakSelf.completeBtn.enabled = NO;
                }
            }
        }
        [weakSelf.completeBtn setTitle:self.selectedArray.count ? [NSString stringWithFormat:@"完成 %ld",self.selectedArray.count] : @"完成" forState:UIControlStateNormal];
        [weakSelf.listView reloadItemsAtIndexPaths:@[indexPath]];
    };
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat scal = 504 * 1.0/375;
    CGFloat wh = (collectionView.bounds.size.width - (self.rowCount + 2) * 5)/self.rowCount;
    return CGSizeMake(wh, wh / scal);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /**进入预览页*/
    
}

#pragma mark --- 进入预览页
-(void)clickPreview{
    
}

-(void)clickCompleted{
    NotificationPost(HZTNOTIFICATION_CHOOSE_PHOTH_COMPLETED, self.selectedArray,nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    NSLog(@"控制器:%@ %@ 被释放",NSStringFromClass([self class]),self.navigationItem.title);
}

@end
