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
/***/
@property (nonatomic, strong) NSMutableArray <HZTAssetModel *>* selectedArray;
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
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        CGFloat btnW = [ToolBaseClass getWidthWithString:[_completeBtn currentTitle] font:_completeBtn.titleLabel.font];
        _completeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - btnW - 10, 10,btnW, toolHeight - 20);
        _completeBtn.enabled = NO;
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toolView addSubview:_completeBtn];
    }
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


-(void)setAssetsFilter:(ALAssetsFilter *)assetsFilter{
    _assetsFilter = assetsFilter;
    [self.groupListView setGroupWithAssetsFilter:assetsFilter];
}

#pragma mark --- 选中分组 本地相册
- (void)didSelectGroup:(ALAssetsGroup *)assetsGroup {
    //[self hidenGroupView];
    //[self showLoadingAnimation];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadAssets:assetsGroup];
    });
}

#pragma mark --- 从系统相册加载图片
- (void)loadAssets:(ALAssetsGroup *)assetsGroup {
    [self.selectedItems removeAllObjects];
    [self.listDataArray removeAllObjects];
    NSMutableArray * tempList = [[NSMutableArray alloc] init];
    /**默认第一个为相机按钮*/
    //[tempList addObject:[KEVThemeManager imageNamed:self.photoImageName]];
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            [tempList addObject:asset];
        } else if (tempList.count > 0) {
            /**排序*/
            NSArray * sortedList = [tempList sortedArrayUsingComparator:^NSComparisonResult(ALAsset *first, ALAsset *second) {
                if ([first isKindOfClass:[UIImage class]]) {
                    return NSOrderedAscending;
                }
                id firstData = [first valueForProperty:ALAssetPropertyDate];
                id secondData = [second valueForProperty:ALAssetPropertyDate];
                /**降序*/
                return [secondData compare:firstData];
            }];
            for (int i = 0; i< sortedList.count; i++) {
                HZTAssetModel * model = [[HZTAssetModel alloc] init];
                ALAsset * asset = sortedList[i];
                if (![asset isKindOfClass:[UIImage class]]) {
                    model.coverImage = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                    model.isSelected = false;
                    model.durationValue = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
                    model.type = [asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo ? AssetType_Video : AssetType_Image;
                    model.videoUrl = model.type == AssetType_Video ? [NSString stringWithFormat:@"%@",[[asset defaultRepresentation] url]] : @"";
                    model.isAdd = false;
                    [self.listDataArray addObject:model];
                }else{
                    model.isAdd = true;
                    model.coverImage = sortedList[i];
                    model.isSelected = false;
                    model.type = AssetType_Image;
                    [self.listDataArray addObject:model];
                }
            }
            /**屏蔽超过5分钟的视频*/
            [self.listDataArray enumerateObjectsUsingBlock:^(HZTAssetModel * asset, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![asset isKindOfClass:[UIImage class]]) {
                    if (asset.type == AssetType_Video) {
                        /**过滤超过一定时长的数据*/
                    }
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                /**数据都处理好之后刷新*/
                //[self hideLoadingAnimation];
                [self.listView reloadData];
                [self.listView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                self.navigationItem.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
            });
        }
    };
    [assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    HZTPhotoAlbumListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HZTPhotoAlbumListCell" forIndexPath:indexPath];
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
        [self.completeBtn setTitle:[NSString stringWithFormat:@"完成 %ld",self.selectedArray.count] forState:UIControlStateNormal];
        CGFloat btnW = [ToolBaseClass getWidthWithString:[self.completeBtn currentTitle] font:self.completeBtn.titleLabel.font];
        CGRect frame = self.completeBtn.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width - btnW - 10;
        frame.size.width = btnW;
        weakSelf.completeBtn.frame = frame;
        [weakSelf.listView reloadData];
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

-(void)clickCompleted{
    NotificationPost(HZTNOTIFICATION_CHOOSE_PHOTH_COMPLETED, self.selectedArray,nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    NSLog(@"控制器:%@ %@ 被释放",NSStringFromClass([self class]),self.navigationItem.title);
}

@end
