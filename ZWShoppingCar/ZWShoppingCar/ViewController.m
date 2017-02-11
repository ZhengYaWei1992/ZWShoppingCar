//
//  ViewController.m
//  ZWShoppingCar
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController.h"
#import "ZWThingCell.h"
#import "ZWShoppingCarVC.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ZWThingCellDelegate,CAAnimationDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)CGPoint endPoint;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)CALayer *layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZWThingCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 49)];
    _label.backgroundColor = [UIColor cyanColor];
    _label.text = @"购物车";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.userInteractionEnabled = YES;
    [bottomView addSubview:self.label];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
    [_label addGestureRecognizer:tap];
    _endPoint = [bottomView convertPoint:self.label.center toView:self.view];
}
- (void)labelTap:(UITapGestureRecognizer *)tap{
    ZWShoppingCarVC *shoppingCarVC = [[ZWShoppingCarVC alloc]init];
    [self.navigationController pushViewController:shoppingCarVC animated:YES];
}
#pragma mark - ZWThingCellDelegate
- (void)thingCell:(ZWThingCell *)thingCell didClickBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath{
    //把button在cell坐标转化为在tableView上的坐标
    CGPoint carButtonCenter = btn.center;
    CGPoint point = [thingCell convertPoint:carButtonCenter toView:self.view];
    //控点
    CGPoint controlPoint = CGPointMake(_endPoint.x, point.y);
    //创建一个layer
//    self.layer = [CALayer layer];
    self.layer.hidden = NO;
    self.layer.frame = CGRectMake(0, 0, 40, 40);
    self.layer.position = point;
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    self.layer.cornerRadius = self.layer.frame.size.width/2;
    self.layer.masksToBounds = YES;
    [self.view.layer addSublayer:self.layer];
    
    //创建关键帧
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    //动画时间
    animation.duration = 0.5;
    //当动画完成，停留到结束位置
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //当方法名字遇到create,new,copy,retain，都需要管理内存
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起点
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x, controlPoint.y, _endPoint.x, _endPoint.y);
    //设置动画路径
    animation.path = path;
    //执行动画
    [self.layer addAnimation:animation forKey:nil];
    //释放路径
    CGPathRelease(path);
    
}
#pragma mark -CAAnimationDelegate
//加入购物车动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画结束隐藏Layer
    _layer.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWThingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.thingLabel.text = (NSString *)self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CALayer *)layer{
    if (_layer == nil) {
        _layer = [CALayer layer];
    }
    return _layer;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (NSInteger i = 0; i < 20; i++) {
            [_dataSource addObject:[NSString stringWithFormat:@"商品%ld",i]];
        }
    }
    return _dataSource;
}


@end
