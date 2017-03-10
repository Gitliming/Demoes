//
//  NewNoteViewController.swift
//  aha
//
//  Created by xpming on 16/9/5.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {
    @IBOutlet weak var noteView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTitle(){
        title = "新增笔记"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: #selector(NewNoteViewController.addNote))
//        Notifications.beginInputNote.addObserver(self, selector: #selector(NewNoteViewController.beginInput))
    }
    //MARK: 添加完成
    func addNote() {
        if noteView.text == "请输入内容" || noteView.textColor == UIColor(red: 0.666667, green: 0.666667, blue: 0.666667, alpha: 1){
//            alert("请输入内容")
            return
        }
        noteView.endEditing(true)
        let desc = noteView.text
        var title:String?
        if desc.characters.count > 20 {
            let indexstart = desc.startIndex.advancedBy(20)
            title = desc.substringToIndex(indexstart)
        }
        title = desc
//            api.manageNote.put(["title":title!, "desc":desc],callback: { (response:LDApiResponse<MyNote>) in
//            response.success({ (msg) in
//              self.navigationController?.popViewControllerAnimated(true)
//            })
//        })
    }
    
    func beginInput(){
        if noteView.text == "请输入内容" {
            noteView.text = ""
        }
        noteView.textColor = UIColor.darkTextColor()
    }
    
    deinit{
//        Notifications.beginInputNote.removeObserver(self)
    }
}
