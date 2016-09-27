//
//  Car.h
//  FMDB的demo
//
//  Created by 欧晓杰 on 2016/9/26.
//  Copyright © 2016年 欧晓杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject

/** 所有者 */
@property(nonatomic,strong) NSNumber *own_id;
/** 车的ID */
@property(nonatomic,strong) NSNumber *car_id;

//车的品牌
@property(nonatomic,copy) NSString *brand;
//车的价格
@property(nonatomic,assign) NSInteger price;

@end
