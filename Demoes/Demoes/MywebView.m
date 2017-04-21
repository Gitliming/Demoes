//
//  MywebView.m
//  lianxi
//
//  Created by 张丽明 on 2017/4/7.
//  Copyright © 2017年 张丽明. All rights reserved.
//

#import "MywebView.h"

@implementation MywebView

-(void)loadPage{
    
    NSString * urlStr = [[NSBundle mainBundle] pathForResource:@"testPage.html" ofType:nil];
    [self loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

@end
