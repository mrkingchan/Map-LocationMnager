//
//  CallAnnotation.h
//  Map&LocationMnager
//
//  Created by Chan on 2016/12/28.
//  Copyright © 2016年 Chan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CallAnnotation : NSObject <MKAnnotation>
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) NSString  *backImageUrl;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate2d imagUrl:(NSString *)imgeUrL;

@end
