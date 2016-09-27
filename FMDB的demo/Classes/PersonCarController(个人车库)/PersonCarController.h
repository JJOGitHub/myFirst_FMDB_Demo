//
//  PersonCarController.h
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person;
@interface PersonCarController : UITableViewController
/** 数据模型 */
@property(nonatomic,strong) Person *person;
@end
