//
//  HZTImageBrowserSubView.m
//  HZTImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "HZTImageBrowserSubView.h"
#import "HZTImageBrowserModel.h"
#import "HZTImageBrowserHeader.h"
#import "UIImageView+WebCache.h"
#import "HZTImageManager.h"
#import "HZTToastView.h"
#import "HZTImageBrowserHeader.h"
#import "AVPlayerViewController+HZTPlayVideoWindow.h"
#import "MPMoviePlayerViewController+HZTPlayVideoWindow.h"
@interface HZTImageBrowserSubView ()<UIScrollViewDelegate>
@property(nonatomic,strong)HZTImageBrowserModel * imageBrowserModel;
@property(nonatomic,strong)UIScrollView * subScrollView;
@property(nonatomic,strong)UIImageView * subImageView;
@property(nonatomic,assign)NSInteger touchFingerNumber;
/**iCloud同步数据进度条*/
@property (nonatomic, strong) UILabel * asyncProgressLabel;
/*视频标记**/
@property (nonatomic, strong) UIImageView * videoFlagView;
/**你的小菊花*/
@property (nonatomic, strong) UIActivityIndicatorView  * indicatorView;
@end

@implementation HZTImageBrowserSubView

- (HZTImageBrowserSubView *)initWithFrame:(CGRect)frame ImageBrowserModel:(HZTImageBrowserModel *)imageBrowserModel {
    if (self = [super initWithFrame:frame]) {
        self.imageBrowserModel = imageBrowserModel;
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.subScrollView];
    [self.subScrollView addSubview:self.subImageView];
    [self.subScrollView addSubview:self.videoFlagView];
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self addGestureRecognizer:singleTap];
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    _imageBrowserModel.bigScrollView = self.subScrollView;
    _imageBrowserModel.bigImageView = self.subImageView;
}

-(void)updateDataWithModel{
    __weak typeof (self)ws = self;
    if (_imageBrowserModel.urlStr) {
        /**网络资源预览*/
        [self.subImageView sd_setImageWithURL:[NSURL URLWithString:_imageBrowserModel.urlStr] placeholderImage:_imageBrowserModel.smallImageView.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) [ws updateSubScrollViewSubImageView];
        }];
    }else{
        /**本地相册图片预览*/
        self.videoFlagView.hidden = _imageBrowserModel.asset.mediaType != PHAssetMediaTypeVideo;
        self.subImageView.image = _imageBrowserModel.smallImageView.image;
        [self updateSubScrollViewSubImageView];
        [[HZTImageManager manager] requestImageDataForAsset:_imageBrowserModel.asset completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            self.subImageView.image = [UIImage imageWithData:imageData];
            self.asyncProgressLabel.hidden = YES;
            [self updateSubScrollViewSubImageView];
        } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            if (error) {
                [HZTToastView showToast:[NSString stringWithFormat:@"async iCloud error async ❌ %@",error.userInfo]];
                NSLog(@"async iCloud error:%@",error.userInfo);
            }else{
                progress = progress > 0.02 ? progress : 0.02;
                NSNumber * num = [NSNumber numberWithDouble:progress * 100];
                self.asyncProgressLabel.text = [NSString stringWithFormat:@"正在同步iColud数据%d%@",[num intValue],@"%"];
                self.asyncProgressLabel.hidden = [num intValue] >= 100;
                NSLog(@"downLoad from iCloud Progress:%.2f  present:%d",progress,[num intValue]);
            }
        }];
    }
}

/**单击 退出*/
- (void)singleTapAction:(UITapGestureRecognizer *)singleTap {
    if ([self.delegate respondsToSelector:@selector(imageBrowserSubViewSingleTapWithModel:)]) {
        [self.delegate imageBrowserSubViewSingleTapWithModel:_imageBrowserModel];
    }
}

/**双击 局部放大 或者 变成正常大小*/
- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    if (self.subScrollView.zoomScale > 1.0) {
        /**已经放大过了 就变成正常大小*/
        [self.subScrollView setZoomScale:1.0 animated:YES];
    } else {
        /**如果是正常大小 就 局部放大*/
        CGPoint touchPoint = [doubleTap locationInView:self.subImageView];
        CGFloat maxZoomScale = self.subScrollView.maximumZoomScale;
        CGFloat width = self.frame.size.width / maxZoomScale;
        CGFloat height = self.frame.size.height / maxZoomScale;
        [self.subScrollView zoomToRect:CGRectMake(touchPoint.x - width/2, touchPoint.y = height/2, width, height) animated:YES];
    }
}

- (void)updateSubScrollViewSubImageView {
    [self.subScrollView setZoomScale:1.0 animated:NO];
    CGFloat imageW = _imageBrowserModel.bigImageSize.width;
    CGFloat imageH = _imageBrowserModel.bigImageSize.height;
    CGFloat height =  imageH == 0 ? 0 : Screen_Width * imageH/imageW;
    if (imageH/imageW > Screen_Height/Screen_Width) {/**长图*/
        self.subImageView.frame =CGRectMake(0, 0, Screen_Width, height);
    }else{
        self.subImageView.frame =CGRectMake(0, Screen_Height/2 - height/2, Screen_Width, height);
    }
    self.subScrollView.contentSize = CGSizeMake(Screen_Width, height);
}

#pragma mark --- scrollView delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.subImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.subImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIPanGestureRecognizer * subScrollViewPan = [scrollView panGestureRecognizer];
    _touchFingerNumber = subScrollViewPan.numberOfTouches;
    _subScrollView.clipsToBounds = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    /**只有是一根手指事件才做出响应*/
    if (contentOffsetY < 0 && _touchFingerNumber == 1) {
        [self changeSizeCenterY:contentOffsetY];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if ((contentOffsetY<0 && _touchFingerNumber==1) && (velocity.y<0 && fabs(velocity.y)>fabs(velocity.x))) {
        /**如果是向下滑动才触发消失的操作*/
        if ([self.delegate respondsToSelector:@selector(imageBrowserSubViewSingleTapWithModel:)]) {
            [self.delegate imageBrowserSubViewSingleTapWithModel:_imageBrowserModel];
        }
    } else {
        [self changeSizeCenterY:0.0];
        CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.subImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
    _touchFingerNumber = 0;
    self.subScrollView.clipsToBounds = YES;
}

- (void)changeSizeCenterY:(CGFloat)contentOffsetY {
    /**contentOffsetY 为负值*/
    CGFloat multiple = (Screen_Height + contentOffsetY*1.75)/Screen_Height;
    if ([self.delegate respondsToSelector:@selector(imageBrowserSubViewTouchMoveChangeMainViewAlpha:)]) {
        [self.delegate imageBrowserSubViewTouchMoveChangeMainViewAlpha:multiple];
    }
    multiple = multiple>0.4?multiple:0.4;
    self.subScrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
    self.subScrollView.center = CGPointMake(Screen_Width/2, Screen_Height/2 - contentOffsetY*0.5);
}

#pragma mark --- UIScrollView
- (UIScrollView *)subScrollView {
    if (_subScrollView == nil) {
        _subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _subScrollView.delegate = self;
        _subScrollView.bouncesZoom = YES;
        /**最大放大倍数*/
        _subScrollView.maximumZoomScale = 2.5;
        /**最小缩小倍数*/
        _subScrollView.minimumZoomScale = 1.0;
        _subScrollView.multipleTouchEnabled = YES;
        _subScrollView.scrollsToTop = NO;
        _subScrollView.contentSize = CGSizeMake(Screen_Width, Screen_Height);
        _subScrollView.userInteractionEnabled = YES;
        _subScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        /**默认yes设置NO则无论手指移动的多么快 始终都会将触摸事件传递给内部控件*/
        _subScrollView.delaysContentTouches = NO;
        /**默认是yes*/
        _subScrollView.canCancelContentTouches = NO;
        /**设置上下回弹*/
        _subScrollView.alwaysBounceVertical = YES;
        _subScrollView.showsVerticalScrollIndicator = NO;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            /**表示只在ios11以上的版本执行*/
            _subScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _subScrollView;
}

- (UIImageView *)subImageView {
    if (_subImageView == nil) {
        _subImageView = [[UIImageView alloc] init];
        _subImageView.image = _imageBrowserModel.smallImageView.image;
        _subImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _subImageView;
}

-(UILabel *)asyncProgressLabel{
    if (!_asyncProgressLabel) {
        _asyncProgressLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _asyncProgressLabel.font = [UIFont systemFontOfSize:18];
        _asyncProgressLabel.textColor = [UIColor whiteColor];
        _asyncProgressLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_asyncProgressLabel];
        [self bringSubviewToFront:_asyncProgressLabel];
    }
    return _asyncProgressLabel;
}

-(UIImageView *)videoFlagView{
    if (!_videoFlagView) {
        CGFloat imgWH = 64;
        _videoFlagView = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_Width-imgWH)/2, (Screen_Height-imgWH)/2,imgWH, imgWH)];
        [_videoFlagView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewVideo)]];
        _videoFlagView.userInteractionEnabled = YES;
        _videoFlagView.hidden = YES;
        _videoFlagView.image = [UIImage imageNamed:@"growth_video_flag"];
    }
    return _videoFlagView;
}

-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, ([UIScreen mainScreen].bounds.size.height - 100) /2, 100, 100);
        [[UIApplication sharedApplication].delegate.window addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark --- 视频预览
-(void)preViewVideo{
    __weak typeof(self) weakSelf = self;
    [self.indicatorView startAnimating];
    PHVideoRequestOptions * options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    PHImageManager * manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:_imageBrowserModel.asset
                            options:options
                      resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                          /**asset 类型为 AVURLAsset  为此资源的fileURL*/
                          /**<AVURLAsset: 0x283386e60, URL = file:///var/mobile/Media/DCIM/100APPLE/IMG_0049.MOV>*/
                          AVURLAsset *urlAsset = (AVURLAsset *)asset;
                          NSLog(@"urlAssetUrl:%@",urlAsset.URL);
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if (urlAsset.URL) {
                                  if (@available(iOS 9.0, *)) {
                                      AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
                                      [playerController playVideoWithURL:urlAsset.URL];
                                  }else {
                                      MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:urlAsset.URL];
                                      [playerController show];
                                  }
                              }
                              [weakSelf.indicatorView stopAnimating];
                          });
                      }];
}

@end
