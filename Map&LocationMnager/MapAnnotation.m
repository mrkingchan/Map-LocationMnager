//
//  MapAnnotation.m
//  JETIN reView
//
//  Created by Chan on 2016/12/26.
//  Copyright © 2016年 Chan. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtile
      andCoordinate:(CLLocationCoordinate2D)coordinate2d
    andbackImageUrl:(NSString *)imgUrl {
    self.title = title;
    self.subtitle = subtile;
    self.coordinate = coordinate2d;
    _backImageUrl = imgUrl;
    return self;
}
@end
