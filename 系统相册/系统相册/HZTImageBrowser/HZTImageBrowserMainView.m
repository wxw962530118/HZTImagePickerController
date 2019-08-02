//
//  HZTImageBrowserMainView.m
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "HZTImageBrowserMainView.h"
#import "HZTImageBrowserHeader.h"
#import "HZTImageBrowserModel.h"
#import "HZTImageBrowserSubView.h"

@interface HZTImageBrowserMainView ()<UIScrollViewDelegate,HZTImageBrowserSubViewDelegate>
@property(nonatomic,strong)UIScrollView * mainScrollView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,copy)NSArray <HZTImageBrowserModel *>* browserModels;
@property(nonatomic,copy)NSArray * originImageViews;
/***/
@property (nonatomic, assign) BOOL isFromPicker;
/**/
@property (nonatomic, strong) UIImageView * originImageView;
/***/
@property (nonatomic, strong) UIView * topToolView;
/***/
@property (nonatomic, strong) UIView * bottomToolView;
/***/
@property (nonatomic, strong) NSMutableArray <HZTImageBrowserSubView *>* browserSubViews;
@end

@implementation HZTImageBrowserMainView

+ (instancetype)imageBrowserMainViewUrlStr:(NSArray<HZTImageBrowserModel *>*)browserModels originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage isFromPicker:(BOOL)isFromPicker{
    HZTImageBrowserMainView * imageBrowserMainView = [[HZTImageBrowserMainView alloc] initWithFrame:Screen_Frame];
    imageBrowserMainView.isFromPicker = isFromPicker;
    imageBrowserMainView.browserModels = browserModels;
    imageBrowserMainView.originImageViews = originImageViews;
    imageBrowserMainView.selectPage = selectPage;
    [imageBrowserMainView initData];
    [imageBrowserMainView initView];
    return imageBrowserMainView;
}

- (void)initData {
    for (NSInteger i = 0; i < self.browserModels.count; i++) {
        HZTImageBrowserModel * imageBrowserModel  = self.browserModels[i];
        UIImageView * imageView = self.originImageViews[i];
        imageBrowserModel.smallImageView = imageView;
        [self.dataSource addObject:imageBrowserModel];
    }
}

- (void)initView {
    /**1.初始化 mianScrollView*/
    [self addSubview:self.mainScrollView];
    /**加入子视图 这里要替换成UICollectionView 或者 自己实现复用机制*/
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        HZTImageBrowserSubView * imageBrowserSubView = [[HZTImageBrowserSubView alloc] initWithFrame:CGRectMake((Screen_Width + SpaceWidth)*i, 0, Screen_Width, Screen_Height) ImageBrowserModel:self.dataSource[i]];
        imageBrowserSubView.delegate = self;
        [self.browserSubViews addObject:imageBrowserSubView];
        [self.mainScrollView addSubview:imageBrowserSubView];
    }
    
    [self.mainScrollView setContentSize:CGSizeMake((Screen_Width + SpaceWidth)*self.dataSource.count, 0)];
    [self.mainScrollView setContentOffset:CGPointMake((Screen_Width + SpaceWidth)*_selectPage, 0)];
    /**2.设置 pagecontel*/
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.dataSource.count;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.dataSource.count];
    self.pageControl.frame = CGRectMake(Screen_Width/2-size.width/2, Screen_Height-size.height-20, size.width, size.height);
    self.pageControl.currentPage = _selectPage;
    HZTImageBrowserSubView * selectBrowserSubView = self.browserSubViews[_selectPage];
    [selectBrowserSubView updateDataWithModel];
}

/**转场动画开始结束会会调用这个方法 所以在这里 重新根据isFromPicker判断PageControl的显示*/
- (void)subViewHidden:(BOOL)isHidden {
    if (isHidden) {
        self.mainScrollView.hidden = YES;
        self.pageControl.hidden = YES;
    } else {
        self.mainScrollView.hidden = NO;
        self.pageControl.hidden = NO;
    }
    self.pageControl.hidden = self.isFromPicker;
}

#pragma mark -HZTImageBrowserSubViewDelegate
- (void)imageBrowserSubViewSingleTapWithModel:(HZTImageBrowserModel *)imageBrowserModel {
    if ([self.delegate respondsToSelector:@selector(imageBrowserMianViewSingleTapWithModel:)]) {
        [self.delegate imageBrowserMianViewSingleTapWithModel:imageBrowserModel];
    }
}

- (void)imageBrowserSubViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha {
    if ([self.delegate respondsToSelector:@selector(imageBrowserMainViewTouchMoveChangeMainViewAlpha:)]) {
        [self.delegate imageBrowserMainViewTouchMoveChangeMainViewAlpha:alpha];
    }
}

#pragma mark --- scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger currentPage = currentX / (Screen_Width + SpaceWidth);
    _selectPage = currentPage;
    [self.pageControl setCurrentPage:currentPage];
    HZTImageBrowserSubView * selectBrowserSubView = self.browserSubViews[currentPage];
    [selectBrowserSubView updateDataWithModel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger currentPage = currentX / (Screen_Width + SpaceWidth);
    HZTImageBrowserSubView * selectBrowserSubView = self.browserSubViews[currentPage];
    [selectBrowserSubView updateDataWithModel];
    [self.pageControl setCurrentPage:currentPage];
}

#pragma mark  --- lazy
- (UIScrollView *)mainScrollView {
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width + SpaceWidth, Screen_Height)];
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        /**如果只有一页就隐藏*/
        _pageControl.hidesForSinglePage = YES;
        /**设置page的颜色*/
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        /**设置当前page的颜色*/
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)browserSubViews{
    if (!_browserSubViews) {
        _browserSubViews = [NSMutableArray array];
    }
    return _browserSubViews;
}

@end
