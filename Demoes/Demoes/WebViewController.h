//
//  WebViewController.h
//  lianxi
//
//  Created by 张丽明 on 2017/4/7.
//  Copyright © 2017年 张丽明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol testDelegate <NSObject>

-(void)changeString:(NSString *)title;

@end

@interface WebViewController : UIViewController
@property(nonatomic,weak)id<testDelegate>teDelegate;


-(void)openCamare;

@end
