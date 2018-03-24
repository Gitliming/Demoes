//
//  InputController.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/23.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit
import AVFoundation

class InputController: BaseViewController {

    var intputFile:UITextField?
    var outputButton:UIButton?
    var scanButton:UIButton?
    let screenWidth = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        view.layer.contents = UIImage(named: "h")?.cgImage
        title = "二维码工厂"
        intputFile = UITextField(frame: CGRect(x: (screenWidth - 200)/2, y: 100, width: 200, height: 44))
        intputFile?.backgroundColor = UIColor.white
        intputFile?.borderStyle = .roundedRect
        intputFile?.keyboardAppearance = UIKeyboardAppearance.default
        outputButton = UIButton(frame: CGRect(x: (screenWidth - 100)/2, y: 164, width: 100, height: 30))
        outputButton?.addTarget(self, action: #selector(InputController.outputAction), for: UIControlEvents.touchUpInside)
        outputButton?.setTitle("生成二维码", for: UIControlState())
        outputButton?.setBackgroundImage(UIImage(named:"l" ), for: UIControlState())
        view.addSubview(intputFile!)
        view.addSubview(outputButton!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(InputController.scanAction))
    }
    
    func scanAction(){
//        let authorionSatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        let scanVc = QRScanController()
//        if authorionSatus != AVAuthorizationStatus.Authorized{
            let rect = CGRect(origin: view.center, size: CGSize.zero)
            (navigationController as! CustomAnimaViewNavigation).pushViewController(scanVc, Rect: rect, animated: true)
//        }else{
//            let url = NSURL(string: UIApplicationOpenSettingsURLString)
//            
//            if UIApplication.sharedApplication().canOpenURL(url!) == true{
//                UIApplication.sharedApplication().openURL(url!, options:[:], completionHandler: nil)
//            }
//            let alertVC = UIAlertController(title: "提示", message: "您的相机权限尚未开启，请前往设置", preferredStyle: .ActionSheet)
//            let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
//            alertVC.addAction(cancelAction)
//            self.presentViewController(alertVC, animated: true, completion: nil)
//        }
    }
    
    func outputAction(){
        intputFile?.endEditing(true)
        
        guard let message = intputFile?.text else{return}
        let showVc = ShowQRController()
        showVc.message = message
        navigationController?.pushViewController(showVc, animated: true)
        print(message)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
