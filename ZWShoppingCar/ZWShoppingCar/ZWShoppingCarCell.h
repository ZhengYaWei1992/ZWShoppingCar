//
//  ZWShoppingCarCell.h
//  ZWShoppingCar
//
//  Created by 郑亚伟 on 2017/2/8.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

typedef void(^SelectedBlock)(UIButton *selectedButton,NSIndexPath *indexPath);
typedef void(^SubBlock)(UIButton *subButton,NSIndexPath *indexPath);
typedef void(^AddBlock)(UIButton *addButton,NSIndexPath *indexPath);

@interface ZWShoppingCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *selecedButton;

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,copy)SelectedBlock selectedBlock;
@property(nonatomic,copy)SubBlock subBlock;
@property(nonatomic,copy)AddBlock addBlock;

@property(nonatomic,strong)Model *model;
@end
