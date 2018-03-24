//
//  ShowQRController.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/23.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class ShowQRController: BaseViewController {
    var QrImgView:UIImageView?
    var saveButton:UIButton?
    var message:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        drawQrImage()
    }
    
    func setupUI(){
        title = "二维码"
        view.layer.contents = UIImage(named: "j")?.cgImage
        QrImgView = UIImageView(frame: CGRect(origin: view.center, size: CGSize(width: 150, height: 150)))
        QrImgView?.center = view.center
        QrImgView?.backgroundColor = UIColor.white
        let y = QrImgView?.frame.maxY
        saveButton = UIButton(frame: CGRect(x: (view.bounds.width - 100)/2, y: y! + 20, width: 100, height: 40))
        saveButton?.setTitle("保存图片", for: UIControlState())
        saveButton?.setBackgroundImage(UIImage(named:"l"), for: UIControlState())
        saveButton?.addTarget(self, action: #selector(ShowQRController.saveImage), for: UIControlEvents.touchUpInside)
        
        view.addSubview(QrImgView!)
        view.addSubview(saveButton!)
        
    }
    
    func saveImage(){
        UIImageWriteToSavedPhotosAlbum((QrImgView?.image)!, self, #selector(ShowQRController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        print("saveSucceful")
    }
    
    func image(_ image:UIImage?, didFinishSavingWithError:NSError?, contextInfo: AnyObject?){
        var Err = ""
        
        if didFinishSavingWithError != nil {
            Err = "保存失败！"
        }else{
        
            Err = "保存成功！"
        }
        
      let alertCtrl = UIAlertController(title: "提示", message: Err, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "sure", style: .default, handler: nil)
        
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    
    
    func drawQrImage() {
        //获取生成的图片
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        if message == "" {
        
        message = "请输入内容。。。"
        }
        let data = message.data(using: String.Encoding.utf8)
        filter?.setValue( data, forKey: "inputMessage")
        var QrImg = filter?.outputImage
        
        //设置二维码的前背景色
        let filterColor = CIFilter(name: "CIFalseColor")
        filterColor?.setDefaults()
        filterColor?.setValue(QrImg, forKeyPath: "inputImage")
        
        ///获取生成的图片无损放大
        QrImg = filterColor?.outputImage
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(QrImg!, from: (QrImg?.extent)!)
        //添加中心标志图
        var QRImage = UIImage(cgImage: cgImage!)
        
        UIGraphicsBeginImageContext((QrImgView?.bounds.size)!)
        let titleImg = UIImage(named: "m")
        let resetContext = UIGraphicsGetCurrentContext()
        resetContext!.interpolationQuality = CGInterpolationQuality.none
        QRImage.draw(in: CGRect(x: 10, y: 10, width: QrImgView!.bounds.size.width - 20, height: QrImgView!.bounds.size.height - 20))
        let rect = CGRect(x: (QrImgView!.bounds.size.width - 30)/2,
                              y: (QrImgView!.bounds.size.height - 30)/2,
                              width: 30, height: 30)
        titleImg?.draw(in: rect)
        
        QRImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        QrImgView?.image = QRImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
