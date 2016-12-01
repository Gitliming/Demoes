//
//  QRScanController.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/23.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate ,UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var scanView:ScanView?
    var guideLabel:UILabel?
    var openPhoto:UIButton?
    var openLight:UIButton?
    
    var imagePicker:UIImagePickerController?
    var session:AVCaptureSession?
    var input:AVCaptureDeviceInput?
    var output:AVCaptureMetadataOutput?
    var preLayer:AVCaptureVideoPreviewLayer?
    var avplayer:AVAudioPlayer?
    var isLightOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scanQR()

    }
    override func viewWillAppear(animated: Bool) {
    }
    override func viewWillDisappear(animated: Bool) {
        session?.stopRunning()
    }
    func setupUI(){
        title = "扫描中。。。"
        view.layer.contents = UIImage(named: "i")?.CGImage
        let scanW:CGFloat = 200
        let point = CGPointMake(view.center.x - scanW/2, view.center.y - scanW/2)
        scanView = ScanView(frame: CGRect(origin: point, size: CGSizeMake(scanW, scanW)))
        
        let y = scanView?.frame.maxY
        guideLabel = UILabel(frame: CGRect(x: (scanView?.frame.origin.x)!, y: y! + 20, width: scanView!.bounds.width, height: 60))
        guideLabel?.text = "请将二维码置于窗口中,将会自动扫描"
        guideLabel?.textColor = UIColor.whiteColor()
        guideLabel?.numberOfLines = 0
        
        let yp = guideLabel?.frame.maxY
        let xp = guideLabel?.frame.minX
        let wp = guideLabel?.bounds.width
        openPhoto = UIButton(frame: CGRect(x: xp!, y: yp!, width: wp!/2 - 2, height: 30))
        openPhoto?.setBackgroundImage(UIImage(named: "l"), forState: .Normal)
        openPhoto?.setTitle("打开相册", forState: .Normal)
        openPhoto?.addTarget(self, action: #selector(QRScanController.openPhotoAction), forControlEvents: .TouchUpInside)
        
        openLight = UIButton(frame: CGRect(x: xp! + wp!/2 + 2, y: yp!, width: wp!/2 - 2, height: 30))
        openLight?.setTitle("打开灯光", forState: .Normal)
        openLight?.setBackgroundImage(UIImage(named: "l"), forState: .Normal)
        openLight?.addTarget(self, action: #selector(QRScanController.openLightAction), forControlEvents: .TouchUpInside)
        
        view.addSubview(scanView!)
        view.addSubview(guideLabel!)
        view.addSubview(openPhoto!)
        view.addSubview(openLight!)
    }
    //扫描成功声音提示
    func scanedSound(){
        let path = NSBundle.mainBundle().pathForResource("qrcode_found.wav", ofType: nil)
        let url = NSURL(fileURLWithPath: path!)
        do{
            avplayer = try AVAudioPlayer(contentsOfURL: url)
            avplayer!.play()
        }catch{
            print(error)
        }
    }
    
    func openPhotoAction(){
        imagePicker = UIImagePickerController()
        imagePicker!.allowsEditing = true
        imagePicker?.delegate = self
        self.presentViewController(imagePicker!, animated: true, completion: nil)
    }
    ///mark:--UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let imageData = UIImageJPEGRepresentation(image, 1)
        //软件渲染消除警告修改Gpu渲染优先级提高渲染效率
        let context = CIContext(options: [kCIContextUseSoftwareRenderer:true, kCIContextPriorityRequestLow:false])
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: nil)
        let ciImage = CIImage(data: imageData!)
        let array = detector!.featuresInImage(ciImage!)
        let feature = array.first as? CIQRCodeFeature
        var message = ""
        if feature != nil {
             print(feature!.messageString)
            message = (feature?.messageString)!
        }else{
            message = "没有扫描到内容"
        }
         scanedSound()
        let alertCtrl = UIAlertController(title: "扫描结果", message: message, preferredStyle: .ActionSheet)

        let alertAction = UIAlertAction(title: "确定", style: .Cancel) { (alertAction) in
            self.session?.startRunning()
        }
        alertCtrl.addAction(alertAction)
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    ///mark:--UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openLightAction(){
       let  device =  AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device.hasTorch {
            do{
               try device.lockForConfiguration()
                if isLightOn == false {
                     device.torchMode = AVCaptureTorchMode.On
                    isLightOn = true
                }else{
                     device.torchMode = AVCaptureTorchMode.Off
                    isLightOn = false
                }

            }catch{
            print(error)
            }
        }else{
        let alertCtrl = UIAlertController(title: "提示", message: "sorry！你的设备不支持！", preferredStyle: .ActionSheet)
        let alertAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertCtrl.addAction(alertAction)
            self.presentViewController(alertCtrl, animated: true, completion: nil)
        }
    }
    
    func scanQR(){
        //创建设备对象
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            input = try AVCaptureDeviceInput.init(device: device)
        }catch{
        print(error)
        }
        output = AVCaptureMetadataOutput()
        session = AVCaptureSession()
        preLayer = AVCaptureVideoPreviewLayer(session: session)
        preLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        preLayer?.frame = (scanView?.frame)!
        view.layer.insertSublayer(preLayer!, atIndex: 0)
        
        if session?.canAddInput(input) == true && input != nil {
            session?.addInput(input)
        }else{
            let alertVc = UIAlertController(title: "提示", message: "对不起！您的设备无法启动相机", preferredStyle: .ActionSheet)
            let alertAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            let alertAction2 = UIAlertAction(title: "返回", style: .Cancel, handler: nil)
            alertVc.addAction(alertAction)
            alertVc.addAction(alertAction2)
            self.presentViewController(alertVc, animated: true, completion: nil)
                return}
        if session?.canAddOutput(output) == true && output != nil{
            session?.addOutput(output)
        }else{return}
        
        //设置数据源为二维码数据源
        output?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        output?.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        let bounds = scanView?.bounds
        let origin = scanView?.frame.origin
        output?.rectOfInterest = CGRectMake((origin?.y)!/screenHeight, (origin?.x)!/screenWidth, 2*(bounds?.height)!/screenHeight , 2*(bounds?.width)!/screenWidth);

        
        //启动扫描
        session?.sessionPreset = AVCaptureSessionPresetHigh
        session?.startRunning()
    }
    //--mark AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        scanedSound()
        session?.stopRunning()
        scanView?.stopAnimating()
        if metadataObjects != nil {
            let obj = metadataObjects.first
            let str = obj?.stringValue
            if str!.hasPrefix("http") {
                let web = UIWebView(frame: CGRectMake(0, 64, view.bounds.width, view.bounds.height - 64))
                let url = NSURL(string: str!)
                web.loadHTMLString("您扫描到的内容是\(str)", baseURL: url)
                view.addSubview(web)
            }else{
                let alertCtrl = UIAlertController(title: "扫描结果", message: str, preferredStyle: .ActionSheet)
                let alertAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (alertAction) in
                    self.session?.startRunning()
                    self.scanView?.startAnimating()
                })
                alertCtrl.addAction(alertAction)
                self.presentViewController(alertCtrl, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
