//
//  BaseModel.h
//  Map&LocationMnager
//
//  Created by Chan on 2016/12/27.
//  Copyright © 2016年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>

+ (instancetype)initWithDic:(NSDictionary *)dic;
@end
