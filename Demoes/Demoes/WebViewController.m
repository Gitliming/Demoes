//
//  WebViewController.m
//  lianxi
//
//  Created by 张丽明 on 2017/4/7.
//  Copyright © 2017年 张丽明. All rights reserved.
//

#import "WebViewController.h"
#import "MywebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <CommonCrypto/CommonDigest.h>

@protocol jsDelegate <JSExport>

-(void)openCamare;

@end

@interface WebViewController ()<UIWebViewDelegate, jsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)MywebView * webView;
@property(nonatomic, strong)JSContext * jsContext;
@property(nonatomic,copy)NSString * deletePath;

@end

@implementation WebViewController
//-(void)loadView{
//    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 667)];
//    NSLog(@"%s",__FUNCTION__);
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[MywebView alloc]initWithFrame:self.view.bounds];
    [self.webView loadPage];
    self.webView.delegate = self;
    [self.view addSubview: self.webView];
    [self getDelegate];
}


-(void)getDelegate{
    if (self.teDelegate) {
        [self.teDelegate changeString:@"testDelegate"];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [self cleanCache];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:-- UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"webOwner"] = self;
    self.jsContext.exceptionHandler = ^(JSContext * jsContext, JSValue * errorValue){
    
        jsContext.exception = errorValue;
        NSLog(@"异常信息：%@",errorValue);
    };

}

//MARK:--jsDelegate

-(void)openCamare{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * pickerVc = [[UIImagePickerController alloc]init];
        [pickerVc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        pickerVc.allowsEditing = YES;
        pickerVc.delegate = self;
        [self presentViewController:pickerVc animated:true completion:nil];

    }else{
        UIAlertController * alertVc = [[UIAlertController alloc]init];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"请打开相机权限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVc addAction:action];
        
        [self presentViewController:alertVc animated:true completion:nil];

    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self cleanCache];
    
    UIImage * img = info[@"UIImagePickerControllerEditedImage"];
    
    NSURL * imgUrl = info[@"UIImagePickerControllerReferenceURL"];
    
    NSString * imageName = [self md5:[imgUrl absoluteString]];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true)lastObject];
    
    NSString * filePath = [path stringByAppendingString:[NSString stringWithFormat:@"%@",imageName]];
    
    self.deletePath = filePath;
    
    
    if ([UIImageJPEGRepresentation(img, 1.0) writeToFile:filePath atomically:YES]){
        
        JSValue * callBack = self.jsContext[@"callBack"];
        
        [callBack callWithArguments:@[filePath]];
    }
    [picker dismissViewControllerAnimated:true completion:nil];
}


-(void)cleanCache{
    if (self.deletePath) {
        [[NSFileManager defaultManager]removeItemAtPath:self.deletePath error:nil];
    }
}


-(NSString *)md5:(NSString *)string{
    const char *cstring = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), digest);
    
    NSMutableString * outputStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [outputStr appendFormat:@"%02x",digest[i]];
    }
    return outputStr;
}


@end
