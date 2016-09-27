//
//  DataBase.m
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"
#import "Person.h"
#import "Car.h"

static DataBase *_dataBase = nil;

@interface DataBase  ()<NSCopying,NSMutableCopying>
{
    //保存实例对象
    FMDatabase *_db;
}
@end

@implementation DataBase
#pragma mark ------------------
#pragma mark 单例
+(instancetype)shareDataBase
{
    if (!_dataBase) {
        _dataBase = [[DataBase alloc] init];
        //创建数据库
        [_dataBase initDataBase];
    }
    return _dataBase;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!_dataBase) {
        _dataBase = [super allocWithZone:zone];
    }
    return _dataBase;
}

-(id)copy
{
    return self;
}

-(id)mutableCopy
{
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}


-(void)initDataBase
{
    //获取Documents目录路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    //文件路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"model.sqlite"];
    
    //实例化FMdataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    
    //打开
    [_db open];
    
    //初始化表格
    NSString *personsql = @"CREATE TABLE 'person' ('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'person_id' INTEGER,'person_name' TEXT,'person_age' integer,    'person_number' integer)";
    
    NSString *carSql = @"create table 'car' ('id' integer not null primary key autoincrement,'own_id' integer,'car_id' integer, 'car_brand' text,'car_price' integer)";
    
    [_db executeUpdate:personsql];
    [_db executeUpdate:carSql];
    
    //关闭
    [_db close];
    
}

#pragma mark ------------------
#pragma mark 接口 person
//把model添加到数据库
-(void)addPerson:(Person *)person
{
    //打开数据库
    [_db open];
    
    NSNumber *maxID = @(0);
    // 查询数据
    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM person"];
    
    // 遍历结果集
    while ([rs next]) {
        //判断是否大于0,或大于上一个id
        if ([maxID integerValue] < [[rs stringForColumn:@"person_id"]integerValue]) {
            maxID = @([[rs stringForColumn:@"person_id"]integerValue]);
        }
    }
    
    maxID = @([maxID integerValue] + 1);
    
    //写入
    [_db executeUpdate:@"insert into person(person_id,person_name,person_age,person_number) values (?,?,?,?)",maxID,person.name,@(person.age),@(person.number)];
    
    //关闭
    [_db close];
}

/**
 *  删除person
 */
-(void)deletePerson:(Person *)person
{
    //打开数据库
    [_db open];
    
    //删除数据
    [_db executeUpdate:@"delete from person where person_id = ?",person.ID];
    
    //关闭数据库
    [_db close];
}

/**
 *  获取所有数据
 */
-(NSMutableArray *)getAllPerson
{
    //打开数据库
    [_db open];
    
    //要返回一个数组,所以要创建
    NSMutableArray *dataArray = [NSMutableArray array];
    
    //查询
    FMResultSet *res = [_db executeQuery:@"select * from person"];
    
    while ([res next]) {
        //创建一个person对象,把数据库的数据赋值给person对象
        Person *person = [[Person alloc]init];
        person.ID = @([[res stringForColumn:@"person_id"] integerValue]);
        person.name = [res stringForColumn:@"person_name"];
        person.age = [[res stringForColumn:@"person_age"] integerValue];
        person.number = [[res stringForColumn:@"person_number"] integerValue];
        
        [dataArray addObject:person];
    }
    
    //关闭数据库
    [_db close];

    return dataArray;
}

#pragma mark ------------------
#pragma mark 接口 car
/**
 *  添加car
 */
-(void)addCar:(Car *)car toPerson:(Person *)person
{
    //打开数据库
    [_db open];
    
    //根据person是否拥有car来添加car_id
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"select * from car where own_id = %@",person.ID]];
    
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"car_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"car_id"] integerValue]);
        }
    }
    maxID = @([maxID integerValue] + 1);
    [_db executeUpdate:@"insert into car(own_id,car_id,car_brand,car_price) values (?,?,?,?)",person.ID,maxID,car.brand,@(car.price)];
    
    //关闭数据库
    [_db close];
}

/**
 *  删除car
 */
-(void)deleteCar:(Car *)car fromPerson:(Person *)person
{
    //打开数据库
    [_db open];
    
    //删除
    [_db executeUpdate:@"delete from car where own_id = ? and car_id = ?",person.ID,car.car_id];
    
    //关闭数据库
    [_db close];
}

/**
 *  获取person所有的car
 */
-(NSMutableArray *)getAllCarsFromPerson:(Person *)person
{
    //打开
    [_db open];
    
    NSMutableArray *carArray = [NSMutableArray array];
    
    NSString *query = [NSString stringWithFormat:@"select * from car where own_id = %@",person.ID];
    
    FMResultSet *res = [_db executeQuery:query];
    while ([res next]) {
        //把数据库的数据赋值给模型
        Car *car = [[Car alloc]init];
        car.car_id = @([[res stringForColumn:@"car_id"] integerValue]);
        car.own_id = person.ID;
        car.brand = [res stringForColumn:@"car_brand"];
        car.price = [[res stringForColumn:@"car_price"] integerValue];
        
        [carArray addObject:car];
    }
    
    //关闭
    [_db close];
    
    return carArray;
}

/**
  *  删除所有的cars
  */
-(void)deleteAllCarsFromPerson:(Person *)person
{
    //打开数据库
    [_db open];
    
    //删除
    [_db executeUpdate:@"delete from car where own_id = ?",person.ID];
    
    //关闭数据库
    [_db close];
}
@end
