//
//  NoteShowViewController.swift
//  aha
//
//  Created by xpming on 16/9/6.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit

class NoteShowViewController: UIViewController {
    var noteModel:MyNote?
    var noteView:UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
    }
    
    func UI(){
        title = "编辑笔记"
        noteView!.text = noteModel?.desc
        noteView!.textColor = UIColor.darkTextColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //编辑笔记
     func addNote() {
        if noteView!.text == noteModel?.desc{
            navigationController?.popViewControllerAnimated(true)
            return
        }
        noteView!.endEditing(true)
        guard let id = noteModel?.id else{return}
        let desc = noteView!.text
        var title:String?
        if desc.characters.count > 20 {
            let indexstart = desc.startIndex.advancedBy(20)
            title = desc.substringToIndex(indexstart)
        }
        title = desc
//        api.manageNote.post(["id":id, "title":title!, "desc":desc]){ (response:LDApiResponse<MyNote>) in
//            response.success({ (msg) in
               self.navigationController?.popViewControllerAnimated(true)
//            })
        }
    }
