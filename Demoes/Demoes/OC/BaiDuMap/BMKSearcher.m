//
//  BMKSearcher.m
//  lianxi
//
//  Created by 张丽明 on 2017/4/24.
//  Copyright © 2017年 张丽明. All rights reserved.
//

#import "BMKSearcher.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKSearchBase.h>
#import <BaiduMapAPI_Search/BMKBusLineSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>

@interface BMKSearcher ()<BMKPoiSearchDelegate,BMKRouteSearchDelegate,BMKBusLineSearchDelegate>

@property(nonatomic,strong)BMKPoiSearch * poiSarcher;
@property(nonatomic,strong)BMKBusLineSearch * busLineSarcher;
@property(nonatomic,strong)BMKRouteSearch * routeSearcher;
@property(nonatomic,assign)int curPage;
@end

@implementation BMKSearcher

- (instancetype)initWithType:(mapSearchType)searchType location:(CLLocation *)userLocation keyWord:(NSString *)keyWord
{
    self = [super init];
    if (self) {
        [self initWithSearcher:searchType location:userLocation keyWord:keyWord];
    }
    return self;
}

-(void)initWithSearcher:(mapSearchType)SearchType location:(CLLocation *)userLocation keyWord:(NSString *)keyWord{
    switch (SearchType) {
        case POI_nearby:
            _poiSarcher = [[BMKPoiSearch alloc]init];
            _poiSarcher.delegate = self;
            [self searchOptionWithLocation:userLocation keyWord:keyWord];
            break;
            
        case POI_BusLine:
            _busLineSarcher = [[BMKBusLineSearch alloc]init];
            _busLineSarcher.delegate = self;
            break;
            
        case POI_Route:
            _routeSearcher = [[BMKRouteSearch alloc]init];
            _routeSearcher.delegate = self;
            break;

        default:
            break;
    }
}

-(void)searchOptionWithLocation:(CLLocation *)userLocation keyWord:(NSString *)keyWord{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageCapacity = 10;
    option.location = userLocation.coordinate;
    option.keyword = keyWord;
    BOOL flag = [_poiSarcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}


//MARK:--BMKPoiSearchDelegate

-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    self.resultPt = ((BMKPoiInfo*)poiResult.poiInfoList[0]).pt;
    self.searchBlock(((BMKPoiInfo*)poiResult.poiInfoList[0]));
}
@end
