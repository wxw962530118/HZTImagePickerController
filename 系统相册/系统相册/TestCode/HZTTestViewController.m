//
//  HZTTestViewController.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/29.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTTestViewController.h"
#import "HZTImagePickerController.h"
#import "HZTPhotoGroupListController.h"
@interface HZTTestViewController ()<UIActionSheetDelegate,HZTImagePickerDelegate>
/***/
@property (nonatomic, strong) HZTImagePickerController * pickerVc;
@end

@implementation HZTTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex:%ld",buttonIndex);
    if (buttonIndex == 0) {
        HZTImagePickerController * vc = [[HZTImagePickerController alloc] initWithMaxCount:9 delegate:self];
        //self.pickerVc = vc;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark --- HZTImagePickerDelegate
-(void)photoPicker:(HZTImagePickerController *)picker didSelectAssets:(NSArray<HZTAssetModel *> *)assets{
    NSLog(@"assets:%@",assets);
}

@end
