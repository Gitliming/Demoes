//
//  NewNoteViewController.swift
//  aha
//
//  Created by xpming on 16/9/5.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit
protocol noteDelegate {
    func addNewNote(note:MyNote)
}
class NewNoteViewController: UIViewController {
    @IBOutlet weak var noteView: UITextView!
    var delegate:noteDelegate?
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
        Notifications.beginInputNote.addObserve(self, object: nil, selecter: #selector(NewNoteViewController.beginInput))
    }
    //MARK: 添加完成
    func addNote() {
        if noteView.text == "请输入内容" || noteView.textColor == UIColor(red: 0.666667, green: 0.666667, blue: 0.666667, alpha: 1){
            alert(massage: "请输入内容")
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
        let timeString = getCurrentTime()
        let noteModel = MyNote(id: timeString, title: title!, desc: desc, createTime: timeString)
        guard let _ = delegate else{return}
        delegate?.addNewNote(noteModel)
        weak var weakSelf = self
        alert(massage: "已添加") { () -> (Void) in
            weakSelf!.navigationController?.popViewControllerAnimated(true)
        }
        asyn { 
            weakSelf!.writeNoteINSQ(noteModel)
        }
    }
    func writeNoteINSQ(note:MyNote){
       let DB = SQLiteManager.SQManager.DB
        DB?.open()
        DB?.executeUpdate("INSERT INTO T_MyNote \n" +
            "(id, title, desc, creatTime) \n" +
                "VALUES \n" +
            "(?, ?, ?, ?);", withArgumentsInArray: [note.id, note.title, note.desc, note.createTime])
        DB?.close()
    }
    func beginInput(){
        if noteView.text == "请输入内容" {
            noteView.text = ""
        }
        noteView.textColor = UIColor.darkTextColor()
    }
    
    deinit{
        Notifications.beginInputNote.removeObserver(self, sender: nil)
    }
}
