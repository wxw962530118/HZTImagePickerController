//
//  HZTImagePickerHeaderController.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/30.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTImagePickerController.h"
#import "HZTMacroNotifications.h"
#import "HZTPhotoGroupListController.h"
@interface HZTImagePickerController ()
/***/
@property (nonatomic, strong) HZTPhotoGroupListController * photoGroupVc;
/***/
@property (nonatomic, weak) id <HZTImagePickerHeaderDelegate> m_delagate;
@end

@implementation HZTImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(instancetype)initWithMaxCount:(NSInteger)maxCount delegate:(id<HZTImagePickerHeaderDelegate>)deleagte{
    if (self = [self init]) {
        self.m_delagate = deleagte;
        self.maxCount = maxCount;
    }
    return self;
}

-(instancetype)init{
    self.photoGroupVc = [HZTPhotoGroupListController new];
    self = [super initWithRootViewController:self.photoGroupVc];
    if (self = [super init]) {
        [self addObserVers];
    }
    return self;
}

-(void)addObserVers{
    NotificationRegister(HZTNOTIFICATION_CHOOSE_PHOTH_COMPLETED,self, @selector(choosePhotoCompleted:),nil);
}

-(void)choosePhotoCompleted:(NSNotification *)noti{
    NSArray * arr = (NSArray *)noti.object;
    if (self.m_delagate && [self.m_delagate respondsToSelector:@selector(photoPicker:didSelectAssets:)]) {
        [self.m_delagate photoPicker:self didSelectAssets:arr];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)dealloc{
    NotificationRemoveAll(self);
    NSLog(@"控制器:%@ %@ 被释放",NSStringFromClass([self class]),self.navigationItem.title);
}

@end
