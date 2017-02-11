//
//  Model.h
//  ZWShoppingCar
//
//  Created by 郑亚伟 on 2017/2/8.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Model : NSObject
@property(nonatomic,assign)CGFloat price;
@property(nonatomic,assign)NSInteger number;

@property(nonatomic,assign)BOOL isSelected;
@end
