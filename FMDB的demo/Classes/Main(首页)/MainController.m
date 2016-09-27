//
//  MainController.m
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import "MainController.h"
#import "Person.h"
#import "CarController.h"
#import "DataBase.h"
#import "PersonCarController.h"

@interface MainController ()

/** 数据源 */
@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation MainController

//懒加载
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark ------------------
#pragma mark 生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加导航条的两个按钮
    //右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCar)];
    //左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"车库" style:UIBarButtonItemStylePlain target:self action:@selector(watchCars)];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataArray = [[DataBase shareDataBase] getAllPerson];
    
}

#pragma mark ------------------
#pragma mark Action
//添加车辆 (添加数据到数据库)
-(void)addCar
{
    NSLog(@"addData");
    
    NSInteger nameRandom = arc4random_uniform(1001);
    
    NSString *name = [NSString stringWithFormat:@"ouxiaojie_%ld",nameRandom];
    NSInteger age = arc4random_uniform(100)+1;
    
    Person *person = [[Person alloc]init];
    person.name = name;
    person.age = age;
    
    //把model添加到数据库
    [[DataBase shareDataBase] addPerson:person];
    
    //获取数据源
    self.dataArray = [[DataBase shareDataBase] getAllPerson];
    
    //刷新数据
    [self.tableView reloadData];
}

//查看车库
-(void)watchCars
{
    CarController *carVC = [[CarController alloc]init];
    [self.navigationController pushViewController:carVC animated:YES];
}

#pragma mark ------------------
#pragma mark tableview的数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //给模型赋值
    Person *personModel = self.dataArray[indexPath.row];
    
    cell.textLabel.text = personModel.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"age:%ld",personModel.age];
    
    return cell;
    
}

#pragma mark ------------------
#pragma mark tableview代理
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCarController *personCarVC = [[PersonCarController alloc]init];
    //把数据传过去
    personCarVC.person = self.dataArray[indexPath.row];
    
    //跳转
    [self.navigationController pushViewController:personCarVC animated:YES];
}

//设置删除按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { //选中删除按钮
        //拿到数据模型,删除数据,再刷新
        Person *person = self.dataArray[indexPath.row];
        
        //在数据库中删除person数据
        [[DataBase shareDataBase] deletePerson:person];
        //删除person所有车辆
        [[DataBase shareDataBase] deleteAllCarsFromPerson:person];
        
        //重新获取数据源
        self.dataArray = [[DataBase shareDataBase] getAllPerson];
        
        [self.tableView reloadData];
    }
}

@end
