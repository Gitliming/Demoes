//
//  MyNoteCell.swift
//  aha
//
//  Created by xpming on 16/9/4.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit
import Foundation

let notecell = "MyNoteCell"

class MyNoteCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var selectedMark: UIImageView!
    @IBOutlet weak var titleLeading: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var isSelectedStatus: Bool = false{
        didSet{
            if !isEditingStatus{
                return
            }
            if isSelectedStatus{
                selectedMark.image = UIImage(named: "icon_selected")
            }else{
                selectedMark.image = UIImage(named: "icon_unselect")
            }
        }
    }
    
    var isEditingStatus: Bool = false{
        didSet{
            selectedMark.hidden = !isEditingStatus
            selectedMark.image = UIImage(named: "icon_unselect")
            
            if isEditingStatus {
                titleLeading.constant = 45
            }else{
                titleLeading.constant = 15
            }
        }
    }
    
   var noteModel:MyNote? {
    
        didSet{
            titleLabel.text = noteModel?.title
            guard let _ = noteModel?.createTime else{return}
//            self.timeLabel.text = NSDate.timeConvert(noteModel?.updateTime)
        }
    }
}
