//
//  ZWThingCell.h
//  ZWShoppingCar
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWThingCell;

@protocol ZWThingCellDelegate <NSObject>

- (void)thingCell:(ZWThingCell *)thingCell didClickBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath;

@end

@interface ZWThingCell : UITableViewCell

@property(nonatomic,weak)id<ZWThingCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *thingLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property(nonatomic,strong)NSIndexPath *indexPath;
@end
