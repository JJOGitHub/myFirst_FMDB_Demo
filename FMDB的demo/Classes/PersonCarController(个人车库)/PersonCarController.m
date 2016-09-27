//
//  PersonCarController.m
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import "PersonCarController.h"
#import "Person.h"
#import "Car.h"
#import "DataBase.h"


@interface PersonCarController  ()
/** 数据源 */
@property(nonatomic,strong) NSMutableArray *carArray;
@end

@implementation PersonCarController

#pragma mark ------------------
#pragma mark 懒加载
-(NSMutableArray *)carArray
{
    if (!_carArray) {
        _carArray = [NSMutableArray array];
    }
    return _carArray;
}

#pragma mark ------------------
#pragma mark 生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的所有的车",_person.name];
    
    //添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCar)];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //从数据库取值给数据源赋值
    self.carArray =  [[DataBase shareDataBase] getAllCarsFromPerson:self.person];
}

//添加车辆
-(void)addCar
{
    NSLog(@"添加车辆");
    
    Car *car = [[Car alloc]init];;
    car.own_id = self.person.ID;
    
    NSArray *brandArray = [NSArray arrayWithObjects:@"大众",@"丰田",@"比亚迪",@"本田",@"MG",@"宝马",@"捷豹",@"路虎",@"斯巴鲁",@"铃木", nil];
    
    NSUInteger index = arc4random_uniform((int)brandArray.count);
    car.brand = [brandArray objectAtIndex:index];
    car.price = arc4random_uniform(1000000);
    
    //添加到数据库
    [[DataBase shareDataBase] addCar:car toPerson:self.person];
    
    self.carArray = [[DataBase shareDataBase] getAllCarsFromPerson:self.person];
    
    //最后都要刷新ui
    [self.tableView reloadData];
}

#pragma mark ------------------
#pragma mark tableview 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"carcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //给cell传模型赋值
    Car *car = [[Car alloc]init];
    car = self.carArray[indexPath.row];
    
    cell.textLabel.text = car.brand;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"price:¥%ld",car.price];
    
    return cell;
}

#pragma mark ------------------
#pragma mark 设置删除按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Car *car = self.carArray[indexPath.row];
        
        [[DataBase shareDataBase] deleteCar:car fromPerson:self.person];
        
        //重新获取数据
        self.carArray = [[DataBase shareDataBase] getAllCarsFromPerson:self.person];
        
        [self.tableView reloadData];
        
    }
}
@end
