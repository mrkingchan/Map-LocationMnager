//
//  MapAnnotation.h
//  JETIN reView
//
//  Created by Chan on 2016/12/26.
//  Copyright © 2016年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *title;
@property(nonatomic,strong) NSString *subtitle;
@property(nonatomic,strong) NSString  *backImageUrl;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtile
      andCoordinate:(CLLocationCoordinate2D)coordinate2d
    andbackImageUrl:(NSString *)imgUrl;
@end
