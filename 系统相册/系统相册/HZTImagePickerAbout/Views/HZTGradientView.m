//
//  HZTGradientView.m
//  系统相册
//
//  Created by 王新伟 on 2019/7/31.
//  Copyright © 2019年 王新伟. All rights reserved.
//

#import "HZTGradientView.h"

@implementation HZTGradientView
+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setupCAGradientLayer:(NSArray *)colors locations:(NSArray *)locations {
    CAGradientLayer *gradient=(CAGradientLayer*)self.layer;
    gradient.colors = colors;
    gradient.locations = locations;
}

@end
