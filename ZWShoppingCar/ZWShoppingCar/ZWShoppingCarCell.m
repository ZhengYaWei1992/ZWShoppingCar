//
//  ZWShoppingCarCell.m
//  ZWShoppingCar
//
//  Created by 郑亚伟 on 2017/2/8.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWShoppingCarCell.h"


@interface ZWShoppingCarCell ()

@end

@implementation ZWShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (void)setModel:(Model *)model{
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[model price]];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",[model number]];
    self.selecedButton.selected = model.isSelected;
}
- (IBAction)seletedButtonClick:(UIButton *)sender {
    if (_selectedBlock) {
        _selectedBlock(sender,self.indexPath);
    }
}

- (IBAction)subButton:(UIButton*)sender {
    if (_subBlock) {
        _subBlock(sender,self.indexPath);
    }
}

- (IBAction)addButton:(UIButton *)sender {
    if (_addBlock) {
        _addBlock(sender,self.indexPath);
    }
}


@end
