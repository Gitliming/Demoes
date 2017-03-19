//
//  NoteShowViewController.swift
//  aha
//
//  Created by xpming on 16/9/6.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit

class NoteShowViewController: NewNoteViewController {
    var noteModel:MyNote?
    var noteIndexPath:NSIndexPath?
    
    
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
    
    
    //MARK:--编辑笔记
    override func addNote() {
        if noteView!.text == noteModel?.desc{
            navigationController?.popViewControllerAnimated(true)
            return
        }
        noteView!.endEditing(true)
        updateNote()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK:--更新笔记
    func updateNote(){
        let desc = noteView!.text
        noteModel?.createTime = getCurrentTime()
        noteModel?.title = super.cutOutTitle(desc)
        noteModel?.desc = desc
        guard let superVC = self.navigationController?.viewControllers[1] as? MyNoteViewController else {return}
        superVC.noteListView.reloadRowsAtIndexPaths([noteIndexPath!], withRowAnimation: .Automatic)
        asyn_global {
            weakSelf(self)!.updateDBData()
        }
    }
    
    
    //MARK:--更新数据库数据
    func updateDBData(){
        let DB = SQLiteManager.SQManager.DB
        DB?.open()
        let noteId = noteModel!.id
        let sqStr = "UPDATE T_MyNote \n" + "SET id = '\(noteModel!.createTime)', title = '\(noteModel!.title)', desc = '\(noteModel!.desc)', creatTime = '\(noteModel!.createTime)'\n" + "WHERE id is '\(noteId)'"
        if (DB?.executeUpdate(sqStr, withArgumentsInArray: nil))!{
//            print("更新成功")
        }
        DB?.close()
    }
}
