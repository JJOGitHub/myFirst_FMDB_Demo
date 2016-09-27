//
//  DataBase.h
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;
@class Car;
@interface DataBase : NSObject

+(instancetype)shareDataBase;

#pragma mark ------------------
#pragma mark person 接口
/**
 *  添加person
 */
-(void)addPerson:(Person *)person;
/**
 *  删除person
 */
-(void)deletePerson:(Person *)person;
/**
 *  更新person
 */
/**
 *  获取所有数据
 */
-(NSMutableArray *)getAllPerson;

#pragma mark ------------------
#pragma mark car 接口
/**
 *  添加car
 */
-(void)addCar:(Car *)car toPerson:(Person *)person;
/**
 *  删除car
 */
-(void)deleteCar:(Car *)car fromPerson:(Person *)person;
/**
 *  获取person所有的car
 */
-(NSMutableArray *)getAllCarsFromPerson:(Person *)person;
/**
 *  删除所有的cars
 */
-(void)deleteAllCarsFromPerson:(Person *)person;

@end
