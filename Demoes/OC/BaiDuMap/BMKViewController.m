//
//  BMKViewController.m
//  lianxi
//
//  Created by 张丽明 on 2017/4/24.
//  Copyright © 2017年 张丽明. All rights reserved.
//

#import "BMKViewController.h"
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKPoiSearchType.h>
#import "BMKSearcher.h"
#import "BMKAnnotion.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface BMKViewController ()<BMKMapViewDelegate,
                                BMKLocationServiceDelegate,
                                UISearchBarDelegate,
                                BMKMapViewDelegate>

@property(nonatomic,strong)BMKMapView * mapView;
@property(nonatomic,strong)BMKLocationService * locationService;
@property(nonatomic,strong)BMKSearcher * searcher;
@property(nonatomic,strong)UISearchBar * searchView;
@property(nonatomic,assign)BMKUserLocation* userLcation;
@property(nonatomic,assign)BOOL isFollowing;
@property(nonatomic,strong)UIButton * followBtn;

@end

@implementation BMKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMapViewModel];
    [self startLocation];
    [self setSubViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    self.mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMapViewModel{
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.showsUserLocation = YES;
    _mapView.showMapScaleBar = YES;
    _mapView.showMapPoi = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.updateTargetScreenPtWhenMapPaddingChanged = YES;
    _mapView.delegate = self;
    self.view = _mapView;
    


}

-(void)setSubViews{

    _searchView = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    _searchView.delegate = self;
    _searchView.placeholder = @"你想去哪？";
    
    _followBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT -50, 44, 44)];
    [_followBtn addTarget:self action:@selector(followMe) forControlEvents:UIControlEventTouchUpInside];
    [_followBtn setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    self.navigationItem.titleView = _searchView;
    [_mapView addSubview:_followBtn];
}

//MARK:-- UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    _isFollowing = NO;
    if (_userLcation) {
        _searcher = [[BMKSearcher alloc]initWithType:POI_nearby location:_userLcation.location keyWord:searchBar.text];
        __weak BMKViewController *weakSelf = self;
        _searcher.searchBlock = ^(BMKPoiInfo* PointInfo){
            [weakSelf addFlagView:PointInfo];
        };
    }
}

-(void)followMe{
    _isFollowing = true;
}

-(void)startLocation{
    dispatch_async(dispatch_get_main_queue(), ^{
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
        [_locationService startUserLocationService];
    });
}

//MARK:--BMKLocationServiceDelegate

//方向更新
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
    if (_isFollowing) {
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        [_mapView updateLocationData:userLocation];
    }
}

//位置更新,速度
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _userLcation = userLocation;
}

//MARK:-- BMKMapViewDelegate

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    _isFollowing = false;
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKAnnotion class]]) {
        BMKPinAnnotationView * annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"xianghu"];
        annotationView.pinColor = BMKPinAnnotationColorGreen;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

-(void)addFlagView:(BMKPoiInfo *)PointInfo{
    
    BMKAnnotion * annotation = [[BMKAnnotion alloc]init];
    annotation.coordinate = PointInfo.pt;
    annotation.title = PointInfo.name;
       [_mapView addAnnotation:annotation];
}
@end
