//
//  CarController.m
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import "CarController.h"
#import "Car.h"
#import "DataBase.h"
#import "Person.h"

@interface CarController ()
/** person model */
@property(nonatomic,strong) NSMutableArray *dataArray;
/** car model */
@property(nonatomic,strong) NSMutableArray *carArray;

@end

@implementation CarController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

#pragma mark ------------------
#pragma mark 懒加载
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

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
    
    self.title = @"车库";
    self.dataArray = [[DataBase shareDataBase] getAllPerson];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        Person *person = self.dataArray[i];
        NSMutableArray *carAry = [[DataBase shareDataBase] getAllCarsFromPerson:person];
        [self.carArray addObject:carAry];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark ------------------
#pragma mark tableview数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = self.carArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"kucell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //获取模型赋值
    NSMutableArray *carArray = self.carArray[indexPath.section];
    Car *car = carArray[indexPath.row];
    
    cell.textLabel.text = car.brand;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"price: $% ld",car.price];
    
    return cell;

}

//设置header和footer
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

//编辑header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    
    Person *person = self.dataArray[section];
    
    label.text = [NSString stringWithFormat:@"%@的所有的车",person.name];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

#pragma mark ------------------
#pragma mark tableview 代理
/**
 *  设置删除按钮
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *array = self.carArray[indexPath.section];
        
        Car *car = array[indexPath.row];
        Person *person = self.dataArray[indexPath.section];
        //从数据库删除
        [[DataBase shareDataBase] deleteCar:car fromPerson:person];
        
        //重新赋值
        self.dataArray = [[DataBase shareDataBase] getAllPerson];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            Person *person = self.dataArray[i];
            NSMutableArray *carAry = [[DataBase shareDataBase] getAllCarsFromPerson:person];
            [self.carArray addObject:carAry];
        }
        [self.tableView reloadData];
    }
}

@end
