//
//  TestVC.m
//  JETIN reView
//
//  Created by Chan on 2016/12/26.
//  Copyright © 2016年 Chan. All rights reserved.
//

#import "TestVC.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

#import "CustomAnnotationView.h"
@interface TestVC () <CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate , UITableViewDelegate, UITableViewDataSource> {
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    NSMutableDictionary  *_mapItems;
    CLLocationCoordinate2D _userLocation;
    UISearchBar *_search;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark --初始化UI
- (void)setUI {
    //地图
    _mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    _mapView.showsBuildings = YES;
    _mapView.showsPointsOfInterest = YES;
    _mapView.showsScale = YES;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_mapView];
    
    //定位授权
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //8.0以后要请求定位授权
        if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
            [_locationManager  requestWhenInUseAuthorization];
        }
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager  requestAlwaysAuthorization];
        }
        [_locationManager startUpdatingLocation];
    } else {
        NSLog(@"定位服务未开启!");
    }
    _mapItems = [NSMutableDictionary new];
    
    //定位按钮
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 500, 30, 30)];
    imgView.image = [UIImage imageNamed:@"locationself"];
    imgView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(buttonAction:)];
    [imgView addGestureRecognizer:tap];
    [self.view addSubview:imgView];
    //搜索栏
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 20,self.view.bounds.size.width - 40, 40)];
    _search.searchBarStyle = 1;
    _search.delegate = self;
    _search.barTintColor = [UIColor whiteColor];
    [self.view addSubview:_search];
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 60, self.view.bounds.size.width - 40, 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.hidden = YES;
    _dataArray = [NSMutableArray new];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeBoard:)];
    tap2.cancelsTouchesInView = NO;
    _mapView.userInteractionEnabled = YES;
    [_mapView addGestureRecognizer:tap2];
    [_tableView addGestureRecognizer:tap2];
    
    //解码
    NSString *addressstr = @"广东省深圳市宝安区";
    CLGeocoder *coder = [CLGeocoder new];
    [coder  geocodeAddressString:addressstr
               completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                   if (placemarks.count && !error) {
                       for (CLPlacemark *mark in placemarks) {
                           NSLog(@"%.2f",mark.location.coordinate.longitude);
                       }
                   } else if (placemarks.count == 0 &&!error) {
                       NSLog(@"------无数据");
                   } else if (error) {
                       NSLog(@"------->%@",error.localizedDescription);
                   }
               }];
}

#pragma mark --private Method
- (void)hideKeBoard:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
    [_search resignFirstResponder];
}

#pragma mark --CLLocaitonManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    static int  i = 0;
    CLGeocoder *coder = [CLGeocoder new];  //编码解码器
    for (CLLocation *location in locations) {
        MapAnnotation *annotaion = [[MapAnnotation alloc]initWithTitle:[NSString stringWithFormat:@"标注点:%d",i]
                                                              subtitle:[NSString stringWithFormat:@"副标注点:%d",i]
                                                         andCoordinate:location.coordinate
                                    andbackImageUrl:@"Chan"];
        i++;
        [_mapView addAnnotation:annotaion];
        
        //解码
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count && !error) {
                for (CLPlacemark *mark in placemarks) {
                    NSLog(@"--->您的位置信息为:%@--->%@",mark.name,
                          mark.addressDictionary);
                }
            } else if (error) {
                NSLog(@"---------->Error:%@",error.localizedDescription);
            } else if (!error && placemarks.count == 0) {
                NSLog(@"--->无位置信息返回!");
            }
        }];
    }
    
    //编码
    NSString *locaitonStr = @"广东省深圳市宝安区";
    [coder geocodeAddressString:locaitonStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //遍历地址信息
        if (placemarks.count && !error) {
            for (CLPlacemark *mark in placemarks) {
                CLLocation *location = mark.location;
                MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:mark];
                //地址信息都存放在addresDic字典中
                NSLog(@"--------%@\n",mark.addressDictionary);
            }
        } else if (!error && placemarks.count == 0) {
            NSLog(@"数据空");
        } else if (error) {
            NSLog(@"------->Error:%@",error.localizedDescription);
        }
    }];
}
 
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"------>Error:%@",error.localizedDescription);
    
    
    [_locationManager stopUpdatingLocation];
}

#pragma mark --MkMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        MapAnnotation *senderAnnotation = (MapAnnotation *)annotation;
        senderAnnotation.backImageUrl = @"Chan";
        static NSString *kID = @"Chan1";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:kID];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation
                                                             reuseIdentifier:kID];
        }
        annotationView.annotation = senderAnnotation;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chan"]];
        annotationView.leftCalloutAccessoryView = imgView ;
        annotationView.calloutOffset=CGPointMake(0, 1);
        UIImage  *image = [UIImage imageNamed:@"Chan"];
        annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:image];
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        return annotationView;
    } else if ([annotation isKindOfClass:[CallAnnotation class]]) {
        CallAnnotation  *callAnnotation = (CallAnnotation *)annotation;
        static NSString *kID = @"Chan2";
        CustomAnnotationView *annotationView = (CustomAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:kID];
        if (!annotationView) {
            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:callAnnotation reuseIdentifier:kID];
        }
        annotationView.image = [UIImage imageNamed:@"Chan"];
        annotationView.imageView.image = [UIImage imageNamed:callAnnotation.backImageUrl];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    if ([mapView.userLocation.title containsString:@"Current"]) {
        mapView.userLocation.title = @"Chan";
    }
    return nil;
}

#pragma mark --private Method
- (void)buttonAction:(id)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        /*UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
         MKAnnotationView *annotationView = (MKAnnotationView *)tap.view;
         MapAnnotation *annotation = (MapAnnotation *)annotationView.annotation;
         NSLog(@"%@----%@",annotation.title,annotation.subtitle);*/
        NSLog(@"点击了左边图标");
        NSLog(@"%.2f----%.2f",_userLocation.latitude,_userLocation.longitude);
        [_mapView setRegion:MKCoordinateRegionMake(_userLocation, MKCoordinateSpanMake(0.5, 0.5)) animated:YES];
    }
}

//查找附近
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _userLocation = userLocation.location.coordinate;
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Technology";
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001,0.001);
    //范围 以用户位置为中心的圆内
    request.region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //查找附近
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        for (MKMapItem *item in response.mapItems) {
            NSLog(@"-:%@--%@--%@--%@",item.name,item.placemark.location,item.phoneNumber,item.url);
            //添加大头针
            /*MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithTitle:item.name
                                                                       subtitle:item.phoneNumber
                                                                  andCoordinate:item.placemark.location.coordinate
                                            andbackImageUrl:@"Chan"];
            [_mapView addAnnotation:mapAnnotation];*/
            CallAnnotation *annotatiton = [[CallAnnotation alloc] initWithCoordinate:item.placemark.location.coordinate imagUrl:@"Chan"];
            annotatiton.backImageUrl = @"Chan";
            annotatiton.title = item.name;
            annotatiton.subtitle = item.phoneNumber;
            annotatiton.coordinate = item.placemark.location.coordinate;
            [_mapView addAnnotation:annotatiton];
            //            [_mapItems setValue:mapAnnotation.title forKey:mapAnnotation.subtitle];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    /*if ([view.annotation isKindOfClass:[MapAnnotation class]]) {
        MapAnnotation *annotation = (MapAnnotation *)view.annotation;
        CallAnnotation *callAnnotation = [CallAnnotation new];
        callAnnotation.title = annotation.title;
        callAnnotation.subtitle = annotation.subtitle;
        callAnnotation.backImageUrl = annotation.backImageUrl;
        callAnnotation.coordinate = annotation.coordinate;
        [_mapView removeAnnotation:annotation];
        [_mapView addAnnotation:callAnnotation];
    }else {
        view.canShowCallout = YES;
    }
    if (annotation.subtitle) {
        NSString *numberStr = [annotation.subtitle stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberStr = [numberStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
        numberStr = [numberStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        numberStr = [numberStr substringFromIndex:3];
        
        NSURL *numberUrl = [NSURL URLWithString:numberStr];
        if ([[UIApplication sharedApplication] canOpenURL:numberUrl]) {
            [[UIApplication sharedApplication] openURL:numberUrl];
        } else {
            NSLog(@"不支持的电话号码");
        }
    }*/
}

/*- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view  {
    [self removeCustomAnnotation];
}

-(void)removeCustomAnnotation{
    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CallAnnotation class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
}*/

/*- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSArray *annotationArray = mapView.annotations;
    for (MapAnnotation *annotation in annotationArray) {
        NSLog(@"%@---->%@",annotation.title,annotation.subtitle);
    }
}*/

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    //停止定位用户信息
    NSLog(@"停止定位用户信息");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"---------你点击了%@",control);
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //根据关键字请求数据
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = searchText;
    MKCoordinateSpan span = MKCoordinateSpanMake(1,1);
    //范围 以用户位置为中心的圆内
    request.region = MKCoordinateRegionMake(_userLocation, span);
    //查找附近
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (response.mapItems.count) {
            for (MKMapItem *item in response.mapItems) {
                NSLog(@"-:%@--%@--%@--%@",item.name,item.placemark.location,item.phoneNumber,item.url);
                //添加大头针
                MapAnnotation *mapAnnotation = [[MapAnnotation alloc] initWithTitle:item.name
                                                                           subtitle:item.phoneNumber
                                                                      andCoordinate:item.placemark.location.coordinate
                                                andbackImageUrl:@"Chan"];
                
                [_mapView addAnnotation:mapAnnotation];
                _tableView.hidden = NO;
                [_dataArray addObject:item.name];
                [_tableView reloadData];
            }
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    for (MKAnnotationView *view in views) {
        view.backgroundColor = [UIColor redColor];
    }
}

#pragma mark --UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kcellID = @"kcellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    puts(__func__);
}

#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_search resignFirstResponder];
}
@end
