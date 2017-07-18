//
//  RootTabBarController.swift
//  Demoes
//
//  Created by 张丽明 on 2017/7/1.
//  Copyright © 2017年 xpming. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    //tabBar子控件
    private var viewArray = [UIView]()
    
    private let tabBarOfHeight:CGFloat = 64

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加tabBar顶部自定义圆弧
        let customV:UIView = RootTabBarView(frame:CGRectMake(0, 0, screenWidth, tabBarOfHeight))
        
        customV.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        tabBar.addSubview(customV)
        
        
        //添加子控制器
        creatSubVc()
        
        
        //清除tabBar顶部线
        clearTopLineOfTabBar()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillLayoutSubviews() {
        
        //调整tabBar高度
        var rect = tabBar.frame
        
        rect.origin.y = view.bounds.height - tabBarOfHeight
        
        rect.size.height = tabBarOfHeight
        
        tabBar.frame = rect
        
        tabBar.barStyle = .Default
        
        //调整tabBarItem图片位置
        
        for i in 0..<tabBar.items!.count{
        
            if i == 1 {
                
                tabBar.items![i].imageInsets = UIEdgeInsetsMake(2.5, 0, -2.5, 0)

            }else{
                
                tabBar.items![i].imageInsets = UIEdgeInsetsMake(10, 0, -10, 0)

            }
            
        }

    }
    
    
    
    //MARK:--animaton  toDo
    
    override func viewDidAppear(animated: Bool) {
        
//        startAnimation()
    }
    
    private func startAnimation(){
        viewArray.removeAll()
        
        for i in 0..<tabBar.subviews.count{
            
            viewArray.append(tabBar.subviews[i])
            
            for j in 0..<viewArray.count{
                
                let v = viewArray[j]
            
            v.layer.removeAllAnimations()
            
            if j == 3 {
                
                    animationWithView(v)
                }
            
            }
            
        }
        
    }
    
    
    //MARK:-- 定义动画
    
    func animationWithView(aniView:UIView){
    
        let layer = aniView.layer
        
        //第一部分动画
        
        let animationScare = CABasicAnimation(keyPath:"transform.scare" )
    
        animationScare.fromValue = 1.0
        
        animationScare.toValue = 0.8
        
        animationScare.repeatCount = MAXFLOAT
        
        animationScare.duration = 0.8
        
        animationScare.autoreverses = true
        
        //第二部分动画
        
        let animationAlpha = CABasicAnimation(keyPath: "opacity")
        
        animationAlpha.fromValue = 1.0
        
        animationAlpha.toValue = 0.7
        
        animationAlpha.repeatCount = MAXFLOAT
        
        animationAlpha.duration = 0.8
        
        animationAlpha.autoreverses = true
        
        //添加动画
        
        layer.addAnimation(animationScare, forKey: "transform.scare")
        
        layer.addAnimation(animationAlpha, forKey: "opacity")
    }
    
    
    //MARK:--清除tabBar顶部线
   private func clearTopLineOfTabBar() {
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height)
        
        UIGraphicsBeginImageContext(rect.size)
    
        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        tabBar.backgroundImage = img
        
        tabBar.shadowImage = img
        
    }
    
    
    //MARK:--添加自控制器
    private func creatSubVc() {
        
        let one:UINavigationController = setSubVc(HomeViewController(), title: "首页", NormalImgName: "tab_icon_life", selectImgName:"tab_icon_life2")
        
        one.tabBarItem.tag = 0
        

        
        let two:UINavigationController = setSubVc(AddressController(), title: "通讯录", NormalImgName:"b-1", selectImgName: "b-1")
        
        two.tabBarItem.tag = 1
        
        let three:UINavigationController = setSubVc(InputController(), title: "二维码", NormalImgName: "tab_icon_mine", selectImgName: "tab_icon_mine2")
        
        three.tabBarItem.tag = 2
        
        viewControllers = [one, two, three]
        
    }
    
        
    
    //MARK:--设置子控制器
    private func setSubVc(vc:UIViewController, title:String, NormalImgName:String, selectImgName:String) -> UINavigationController{
        
        let nav:UINavigationController = CustomAnimaViewNavigation(rootViewController:vc)
        
        nav.navigationItem.title = title
        
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        nav.navigationBar.barTintColor = UIColor.greenColor()
        
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(named: NormalImgName)?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: selectImgName)?.imageWithRenderingMode(.AlwaysOriginal))
        
        
        //设置tabBar字体颜色

        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.darkGrayColor()], forState: .Normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.redColor()], forState: .Highlighted)
        
        return nav
    }

}
