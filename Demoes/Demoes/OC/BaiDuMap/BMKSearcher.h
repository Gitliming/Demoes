//
//  BMKSearcher.h
//  lianxi
//
//  Created by 张丽明 on 2017/4/24.
//  Copyright © 2017年 张丽明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKPoiSearchOption.h>
@class BMKPoiInfo;

 typedef enum {
     POI_nearby = 0,
     POI_Route,
     POI_BusLine
} mapSearchType;

@interface BMKSearcher : NSObject
@property(nonatomic,assign)CLLocationCoordinate2D  resultPt;
@property(nonatomic,copy)void(^searchBlock)(BMKPoiInfo * PointInfo);


- (instancetype)initWithType:(mapSearchType)searchType location:(CLLocation *)userLocation keyWord:(NSString *)keyWord;
@end
