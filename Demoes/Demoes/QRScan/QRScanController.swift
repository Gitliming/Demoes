//
//  QRScanController.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/23.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate ,UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        session?.stopRunning()
    }
    func setupUI(){
        title = "扫描中。。。"
        view.layer.contents = UIImage(named: "i")?.cgImage
        let scanW:CGFloat = 200
        let point = CGPoint(x: view.center.x - scanW/2, y: view.center.y - scanW/2)
        scanView = ScanView(frame: CGRect(origin: point, size: CGSize(width: scanW, height: scanW)))
        
        let y = scanView?.frame.maxY
        guideLabel = UILabel(frame: CGRect(x: (scanView?.frame.origin.x)!, y: y! + 20, width: scanView!.bounds.width, height: 60))
        guideLabel?.text = "请将二维码置于窗口中,将会自动扫描"
        guideLabel?.textColor = UIColor.white
        guideLabel?.numberOfLines = 0
        
        let yp = guideLabel?.frame.maxY
        let xp = guideLabel?.frame.minX
        let wp = guideLabel?.bounds.width
        openPhoto = UIButton(frame: CGRect(x: xp!, y: yp!, width: wp!/2 - 2, height: 30))
        openPhoto?.setBackgroundImage(UIImage(named: "l"), for: UIControlState())
        openPhoto?.setTitle("打开相册", for: UIControlState())
        openPhoto?.addTarget(self, action: #selector(QRScanController.openPhotoAction), for: .touchUpInside)
        
        openLight = UIButton(frame: CGRect(x: xp! + wp!/2 + 2, y: yp!, width: wp!/2 - 2, height: 30))
        openLight?.setTitle("打开灯光", for: UIControlState())
        openLight?.setBackgroundImage(UIImage(named: "l"), for: UIControlState())
        openLight?.addTarget(self, action: #selector(QRScanController.openLightAction), for: .touchUpInside)
        
        view.addSubview(scanView!)
        view.addSubview(guideLabel!)
        view.addSubview(openPhoto!)
        view.addSubview(openLight!)
    }
    //扫描成功声音提示
    func scanedSound(){
        let path = Bundle.main.path(forResource: "qrcode_found.wav", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        do{
            avplayer = try AVAudioPlayer(contentsOf: url)
            avplayer!.play()
        }catch{
            print(error)
        }
    }
    
    func openPhotoAction(){
        imagePicker = UIImagePickerController()
        imagePicker!.allowsEditing = true
        imagePicker?.delegate = self
        self.present(imagePicker!, animated: true, completion: nil)
    }
    ///mark:--UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil)
        let imageData = UIImageJPEGRepresentation(image, 1)
        //软件渲染消除警告修改Gpu渲染优先级提高渲染效率
        let context = CIContext(options: [kCIContextUseSoftwareRenderer:true, kCIContextPriorityRequestLow:false])
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: nil)
        let ciImage = CIImage(data: imageData!)
        let array = detector!.features(in: ciImage!)
        let feature = array.first as? CIQRCodeFeature
        var message = ""
        if feature != nil {
             print(feature!.messageString!)
            message = (feature?.messageString)!
        }else{
            message = "没有扫描到内容"
        }
         scanedSound()
        let alertCtrl = UIAlertController(title: "扫描结果", message: message, preferredStyle: .actionSheet)

        let alertAction = UIAlertAction(title: "确定", style: .cancel) { (alertAction) in
            self.session?.startRunning()
        }
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    ///mark:--UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func openLightAction(){
       let  device =  AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! {
            do{
               try device?.lockForConfiguration()
                if isLightOn == false {
                     device?.torchMode = AVCaptureTorchMode.on
                    isLightOn = true
                }else{
                     device?.torchMode = AVCaptureTorchMode.off
                    isLightOn = false
                }

            }catch{
            print(error)
            }
        }else{
        let alertCtrl = UIAlertController(title: "提示", message: "sorry！你的设备不支持！", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertCtrl.addAction(alertAction)
            self.present(alertCtrl, animated: true, completion: nil)
        }
    }
    
    func scanQR(){
        //创建设备对象
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
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
        view.layer.insertSublayer(preLayer!, at: 0)
        
        if session?.canAddInput(input) == true && input != nil {
            session?.addInput(input)
        }else{
            let alertVc = UIAlertController(title: "提示", message: "对不起！您的设备无法启动相机", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            let alertAction2 = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            alertVc.addAction(alertAction)
            alertVc.addAction(alertAction2)
            self.present(alertVc, animated: true, completion: nil)
                return}
        if session?.canAddOutput(output) == true && output != nil{
            session?.addOutput(output)
        }else{return}
        
        //设置数据源为二维码数据源
        output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output?.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let bounds = scanView?.bounds
        let origin = scanView?.frame.origin
        output?.rectOfInterest = CGRect(x: (origin?.y)!/screenHeight, y: (origin?.x)!/screenWidth, width: 2*(bounds?.height)!/screenHeight , height: 2*(bounds?.width)!/screenWidth);

        
        //启动扫描
        session?.sessionPreset = AVCaptureSessionPresetHigh
        session?.startRunning()
    }
    //--mark AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        scanedSound()
        session?.stopRunning()
        scanView?.stopAnimating()
        if metadataObjects != nil {
            let obj = metadataObjects.first
            let str = (obj as AnyObject).absoluteString
            if (str??.hasPrefix("http"))! {
                let web = UIWebView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64))
                let url = URL(string: str!!)
                web.loadHTMLString("您扫描到的内容是\(String(describing: str))", baseURL: url)
                view.addSubview(web)
            }else{
                let alertCtrl = UIAlertController(title: "扫描结果", message: str!, preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: { (alertAction) in
                    self.session?.startRunning()
                    self.scanView?.startAnimating()
                })
                alertCtrl.addAction(alertAction)
                self.present(alertCtrl, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
