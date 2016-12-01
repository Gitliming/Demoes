//
//  textXIb.swift
//  text
//
//  Created by xpming on 16/5/23.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit


class textXIb: UIView {
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromeNib()
               //view.hidden = true
        //imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    
    func loadViewFromeNib() {
        
        let bondle = NSBundle(forClass: self.dynamicType)
        
        let nib = UINib(nibName: "textXIb", bundle: bondle)
        
        let vie = nib.instantiateWithOwner(self, options: nil).first as! UIView
        vie.frame = self.bounds
        self.addSubview(vie)

    }
}