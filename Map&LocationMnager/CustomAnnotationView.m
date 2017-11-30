//
//  CustomAnnotationView.m
//  Map&LocationMnager
//
//  Created by Chan on 2016/12/28.
//  Copyright © 2016年 Chan. All rights reserved.
//
#import "CustomAnnotationView.h"
@interface CustomAnnotationView(){
    UIView *_backView;
    UIImageView *_left;
    UILabel *_detail;
    UIImageView *_right;
}
@end

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        _left = [UIImageView new];
        _left.frame = CGRectMake(0, 0, 47,47);

        _right = [UIImageView new];
        _right.frame = CGRectMake(94, 94, 47,47);
        _left.image = _right.image = [UIImage imageNamed:@"Chan"];
        
        _detail = [UILabel new];
        _detail.frame = CGRectMake(47, 47, 80,80);
        _detail.text = @"detail";
        self.leftCalloutAccessoryView = _left;
        self.detailCalloutAccessoryView = _detail;
        self.rightCalloutAccessoryView = _right;
        NSLog(@"self.size%@",NSStringFromCGSize(self.bounds.size));
        NSLog(@"left:%@\nright:%@",NSStringFromCGRect(self.leftCalloutAccessoryView.frame),NSStringFromCGRect(self.rightCalloutAccessoryView.frame));
        /*[self addSubview:_left];
        [self addSubview:_detail];
        [self addSubview:_right];*/
    }
    return self;
}

- (void)setAnnotation:(CallAnnotation *)annotation {
    [super setAnnotation:annotation];
    _imageView.image = [UIImage imageNamed: annotation.backImageUrl];
    self.bounds = CGRectMake(0, 0, 15, 15);
   }

@end
