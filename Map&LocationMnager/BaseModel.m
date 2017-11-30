//
//  BaseModel.m
//  Map&LocationMnager
//
//  Created by Chan on 2016/12/27.
//  Copyright © 2016年 Chan. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
@implementation BaseModel

/*- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    id model = [[self class] new];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [aDecoder decodeObjectForKey:key];
        if (value == nil) {
            continue;
        }
        [model setValue:value forKey:key];
    }
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

+ (id)initWithDic:(NSDictionary *)dic  {
    id model = [[self class] new];
    //遍历属性并一一赋值
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString  *type = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
        NSString *type2 = [NSString stringWithUTF8String:ivar_getTypeEncoding(class_copyIvarList([self class], &count)[i])];
        type2 = [type2 stringByReplacingOccurrencesOfString:@"@\"" withString:@""];
        type2 = [type2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        //二级转换
        Class typeClass = NSClassFromString(type2);
        id value = [dic  objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class] ]&& ![type containsString:@"NS"]) {
            value = [typeClass initWithDic:value];
        }
        if (value) {
            [model setValue:value forKey:key];
        }
    }
    return model;
}

+ (NSMutableDictionary *)toDic {
    id model = [[self class] new];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    unsigned int count = 0;
    //遍历属性 遍历键值
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [model  valueForKey:key];
        if (value) {
            [dic setValue:value forKey:key];
        }
    }
    return dic;
}*/

#pragma mark --编码
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    id model = [[self class] new];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self  class], &count);
    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
//        id value = [self valueForKey:key];
        id value = [aDecoder decodeObjectForKey:key];
        if (value == nil) {
            continue;
        }
        [model setValue:value forKey:key];
    }
    return model;
}

#pragma mark --解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        [aCoder  encodeObject:value forKey:key];
    }
}

#pragma mark --model--->>dic
- (NSDictionary *)toDic {
    id model = [[self class ]new];
    unsigned int count = 0;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i <count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [model  valueForKey:key];
        if (value) {
            [dic setValue:key forKey:value];
        }
    }
    return  dic;
}

#pragma mark --Dic---->model
- (id)initwithDic:(NSDictionary *)dic {
    id model  = [[self class] new];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    //遍历键值
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [dic  objectForKey:key];
        if (value) {
            [model setValue:value forKey:key];
        }
    }
    return model;

}
@end
