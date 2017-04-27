//
//  BMKAnnotion.h
//  lianxi
//
//  Created by 张丽明 on 2017/4/25.
//  Copyright © 2017年 张丽明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>
@interface BMKAnnotion : NSObject<BMKAnnotation>
@property(nonatomic,copy)NSString * title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
