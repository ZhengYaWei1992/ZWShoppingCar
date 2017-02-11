//
//  ZWShoppingCarVC.m
//  ZWShoppingCar
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWShoppingCarVC.h"
#import "ZWShoppingCarCell.h"
#import "Model.h"

@interface ZWShoppingCarVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *selectedArray;
//总价格
@property(nonatomic,assign)CGFloat totalPrice;
//是否全选
@property(nonatomic,assign)BOOL selectAll;
//总价格label
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end

@implementation ZWShoppingCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZWShoppingCarCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}


/**
 需要在这里面写布局，否则xib按照600*600的标准加载，会造成tableview布局不正确
 */
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49);
}
#pragma mark-全选按钮点击事件
- (IBAction)selecteedBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.selectAll = sender.isSelected;
    if (_selectAll) {//全选
        for (Model *model in self.dataSource) {
            model.isSelected = YES;
            [self.selectedArray addObject:model];
        }
    }else{//全不选
        for (Model *model in self.dataSource) {
            model.isSelected = NO;
        }
        [self.selectedArray removeAllObjects];
    }
    [self.tableView reloadData];
    [self calculateTheTotalPrice];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    Model *model = self.dataSource[indexPath.row];
    //布局
     cell.model = model;
    
    __weak __typeof (self) weakSelf = self;
    __weak __typeof(cell) weakCell = cell;
    __weak __typeof(tableView) weakTableView = tableView;
    //选中或取消选中按钮回调事件
    cell.selectedBlock = ^(UIButton *selectedBtn,NSIndexPath *indexPath){
        //*****这是避免界面重复的重点****
        model.isSelected = !model.isSelected;
        [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (model.isSelected) {//选中
            [weakSelf.selectedArray addObject:model];
        }else{//非选中
            [weakSelf.selectedArray removeObject:model];
        }
        //如果要是选中的和数据源一样多，就把全选按钮设置为选中
        if (_selectedArray.count == _dataSource.count) {
            _selectedButton.selected = YES;
        }else{
            _selectedButton.selected = NO;
        }
        [self calculateTheTotalPrice];
    };
    //减少按钮回调
    cell.subBlock = ^(UIButton *subBtn,NSIndexPath *indexpath){
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count--;
        if (count <= 0) {
            return ;
        }
        weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
        model.number = count;
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        if ([_selectedArray containsObject:model]) {
            [_selectedArray removeObject:model];
            [_selectedArray addObject:model];
            [weakSelf calculateTheTotalPrice];
        }
    };
    //增加按钮回调
    cell.addBlock = ^(UIButton *addBtn,NSIndexPath *indexPath){
        
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count++;
        //最多商品不超过10件
        if (count > 10) {
            return;
        }
        weakCell.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
        model.number =  count;
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        
        //点击+号之前，如果没处于选中状态，则将其调为选中状态。模仿京东的情况,主要是在两行====之间的代码
        //==========================================
        if (model.isSelected == NO) {
            model.isSelected = !model.isSelected;
            [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if (model.isSelected) {//选中
                [weakSelf.selectedArray addObject:model];
            }else{//非选中
                [weakSelf.selectedArray removeObject:model];
            }
            //如果要是选中的和数据源一样多，就把全选按钮设置为选中
            if (_selectedArray.count == _dataSource.count) {
                _selectedButton.selected = YES;
            }else{
                _selectedButton.selected = NO;
            }
        }
        //==========================================

        
        if ([_selectedArray containsObject:model]) {
            [_selectedArray removeObject:model];
            [_selectedArray addObject:model];
            [weakSelf calculateTheTotalPrice];
        }
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 计算总价格
- (void)calculateTheTotalPrice{
    CGFloat totalMoney ;
    for (Model *model in _selectedArray) {
        totalMoney += model.price * model.number;
    }
    _totalPrice = totalMoney;
    _totalPriceLabel.text = [NSString stringWithFormat:@"总价格:%.2f",_totalPrice];
}
#pragma mark - 懒加载
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (NSInteger i = 0; i < 15; i++) {
            Model *model = [[Model alloc]init];
            model.number = 1;
            model.price = 100.00;
            model.isSelected = NO;
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}
- (NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


@end
