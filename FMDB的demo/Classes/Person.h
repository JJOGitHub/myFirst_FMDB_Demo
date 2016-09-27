//
//  Person.h
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property(nonatomic,strong) NSNumber *ID;//主键
/** name */
@property(nonatomic,copy) NSString *name;
/** age */
@property(nonatomic,assign) NSInteger age;
/** number */
@property(nonatomic,assign) NSInteger number;

@end
