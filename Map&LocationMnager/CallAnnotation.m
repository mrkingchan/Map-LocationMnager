//
//  CallAnnotation.m
//  Map&LocationMnager
//
//  Created by Chan on 2016/12/28.
//  Copyright © 2016年 Chan. All rights reserved.
//

#import "CallAnnotation.h"

@implementation CallAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate2d imagUrl:(NSString *)imgeUrL{
    self = [super init];
    if (self) {
    self.coordinate = coordinate2d;
    self.backImageUrl = imgeUrL;
    }
    return self;
}
@end
