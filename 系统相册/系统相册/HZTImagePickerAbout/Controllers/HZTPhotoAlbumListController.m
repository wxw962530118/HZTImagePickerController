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
#import "HZTImageBrowserManger.h"
#import "HZTImageBrowserHeader.h"
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
/***/
@property (nonatomic, strong) NSIndexPath * lastIndexPath;
/***/
@property (nonatomic, strong) HZTImageBrowserManger * imageBrowserManger;
@end

@implementation HZTPhotoAlbumListController

-(instancetype)init{
    if (self = [super init]) {
        self.rowCount = 4;
        self.maximumNumberOfSelection = 9;
        self.minimumNumberOfSelection = 1;
        self.isTopFilter = NO;
        self.isChoosePhoto = YES;
        self.isChooseVideo = NO;
    }
    return self;
}

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
    [self addPanGestureRecognizer];
    [self configNavItem];
    [self addBottomToolView];
}

#pragma mark --- 滑动选中图片
-(void)addPanGestureRecognizer{
   UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onPanGes:)];
    [self.view addGestureRecognizer:panGes];
}

#pragma mark --- 根据外界传入的分组相册数据拉取
-(void)setGroupModel:(HZTPhotoGroupModel *)groupModel{
    _groupModel = groupModel;
    if (groupModel) [self didSelectGroup:self.groupModel];
}

-(void)configNavItem{
    self.view.backgroundColor = [UIColor whiteColor];
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
        _completeBtn = [UIButton new];
        [_completeBtn addTarget:self action:@selector(clickCompleted) forControlEvents:UIControlEventTouchUpInside];
        _completeBtn.backgroundColor = [UIColor orangeColor];
        _completeBtn.layer.cornerRadius = 3;
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        CGFloat btnW = 55;
        _completeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - btnW - 10, 10,btnW,30);
        _completeBtn.enabled = NO;
        _completeBtn.alpha = 0.6;
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toolView addSubview:_completeBtn];
        
        _previewBtn = [UIButton new];
        _previewBtn.alpha = 0.6;
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

#pragma mark --- 选中分组 本地相册
- (void)didSelectGroup:(HZTPhotoGroupModel *)groupModel {
    [self.indicatorView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadPhotoAssets:groupModel];
    });
}

/**判断是否是相机胶卷*/
- (BOOL)isCameraRollAlbum:(NSString *)albumName{
    return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"];
}

#pragma mark --- 从系统相册加载图片
- (void)loadPhotoAssets:(HZTPhotoGroupModel *)groupModel{
    __weak typeof(self) weakSelf = self;
    [self.selectedItems removeAllObjects];
    [self.listDataArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [groupModel.result enumerateObjectsUsingBlock:^(PHAsset * asset, NSUInteger idx, BOOL *_Nonnull stop) {
            HZTAssetModel * model = [[HZTAssetModel alloc] init];
            model.asset = asset;
            model.isSelected = false;
            model.isCameraRoll = false;
            [weakSelf.listDataArray addObject:model];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.indicatorView stopAnimating];
            [weakSelf.listView reloadData];
            /**默认滚动到最底部*/
            [weakSelf.listView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.listDataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            weakSelf.navigationItem.title = groupModel.name;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf handleBroswerData];
            });
        });
    });
}

-(void)handleBroswerData{
    self.imageBrowserManger = [HZTImageBrowserManger imageBrowserMangerWithUrlStr:[self getOriginImages] originImageViews:[self getOriginImageViews] originController:self isFromPicker:YES];
}

-(NSArray <UIImageView *>*)getOriginImageViews{
    NSArray <HZTPhotoAlbumListCell *>* arr = [self.listView visibleCells];
    NSMutableArray * tempArr = [NSMutableArray array];
    for (int i = 0; i< arr.count; i++) {
        HZTPhotoAlbumListCell * cell = (HZTPhotoAlbumListCell *)arr[i];
        [tempArr addObject:cell.coverImgView];
    }
    return tempArr;
}

-(NSArray <HZTImageBrowserModel *>*)getOriginImages{
    NSMutableArray * tempArr = [NSMutableArray array];
    NSArray <HZTPhotoAlbumListCell *>* arr = [self.listView visibleCells];
    for (int i = 0; i< arr.count; i++) {
        HZTPhotoAlbumListCell * cell = (HZTPhotoAlbumListCell *)arr[i];
        HZTImageBrowserModel * model = [HZTImageBrowserModel new];
        model.asset = cell.assetModel.asset;
        [tempArr addObject:model];
    }
    return tempArr;
}

#pragma mark --- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    HZTPhotoAlbumListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HZTPhotoAlbumListCell" forIndexPath:indexPath];
    cell.assetModel = self.listDataArray[indexPath.row];
    cell.selectedItemBlock = ^(HZTAssetModel * asset) {
        [weakSelf handleSelectedItemWithIndexPath:indexPath assets:asset];
    };
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat scal = 375 * 1.0/375;
    CGFloat wh = (collectionView.bounds.size.width - (self.rowCount + 2) * 5)/self.rowCount;
    return CGSizeMake(wh, wh / scal);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

#pragma mark --- 进入预览页
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HZTPhotoAlbumListCell * cell = (HZTPhotoAlbumListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSArray <HZTPhotoAlbumListCell *>* arr = [self.listView visibleCells];
    NSInteger index = [arr indexOfObject:cell];
    NSLog(@"index:%ld",index);
    //self.imageBrowserManger.originImageView = cell.coverImgView;
    self.imageBrowserManger.selectPage = index;
    [self.imageBrowserManger showImageBrowser];
}

#pragma mark --- 进入预览页
-(void)clickPreview{
    
}

-(void)clickCompleted{
    NotificationPost(HZTNOTIFICATION_CHOOSE_PHOTH_COMPLETED, self.selectedArray,nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 具体相册分组选择回调
-(void)didSelectGroup:(HZTPhotoGroupModel *)groupModel isAnimation:(BOOL)isAnimation{
    if (self.isTopFilter)  [self didSelectGroup:groupModel];
}

-(void)dealloc{
    NSLog(@"控制器:%@ %@ 被释放",NSStringFromClass([self class]),self.navigationItem.title);
}


#pragma mark --- 滑动选择图片
- (void)onPanGes:(UIPanGestureRecognizer *)panGes{
    CGPoint point = [panGes locationInView:self.listView];
    for (UICollectionViewCell *cell in self.listView.visibleCells) {
        if (CGRectContainsPoint(cell.frame, point)) {
            NSIndexPath * indexPath = [self.listView indexPathForCell:cell];
            if (self.lastIndexPath != indexPath) {
                [self handleSelectedItemWithIndexPath:indexPath assets:self.listDataArray[indexPath.row]];
            }
            self.lastIndexPath = indexPath;
        }
    }
    if (panGes.state == UIGestureRecognizerStateEnded) {
        self.lastIndexPath = nil;
    }
}

#pragma mark --- 选中结果处理
-(void)handleSelectedItemWithIndexPath:(NSIndexPath *)indexPath assets:(HZTAssetModel *)asset{
    [self.selectedArray removeAllObjects];
    asset.isSelected = !asset.isSelected;
    for (HZTAssetModel * model in self.listDataArray) {
        if (model.isSelected) {
            [self.selectedArray addObject:model];
            self.completeBtn.enabled = YES;
        }else{
            if ([self.selectedArray containsObject:model]) {
                [self.selectedArray removeObject:model];
            }
            if (self.selectedArray.count == 0) {
                self.completeBtn.enabled = NO;
            }
        }
    }
    self.previewBtn.alpha = self.completeBtn.alpha = self.selectedArray.count ? 1.0 : 0.6;
    [self.completeBtn setTitle:self.selectedArray.count ? [NSString stringWithFormat:@"完成 %ld",self.selectedArray.count] : @"完成" forState:UIControlStateNormal];
    [self.listView reloadItemsAtIndexPaths:@[indexPath]];
}

@end
