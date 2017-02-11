//
//  ZWThingCell.m
//  ZWShoppingCar
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWThingCell.h"

@implementation ZWThingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)addBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(thingCell:didClickBtn: indexPath:)]) {
        [self.delegate thingCell:self didClickBtn:sender indexPath:self.indexPath];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

@end
