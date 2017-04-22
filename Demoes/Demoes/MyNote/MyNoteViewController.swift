//
//  MyNoteViewController.swift
//  aha
//
//  Created by xpming on 16/9/2.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit

class MyNoteViewController: UIViewController, noteDelegate {
    
    @IBOutlet weak var noteNumber: UIBarButtonItem!
    @IBOutlet weak var noteListView: MyNoteListView!
    @IBOutlet weak var bottomButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        noteListView.getNoteList()
//        Notifications.toNoteDetail.addObserver(self, selector: #selector(MyNoteViewController.toShowNote(_:)), sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
//        noteListView.refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func setupUI(){
        if noteListView.edite == false{
        title = "我的笔记"
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"编辑", style: .Plain, target: self, action: #selector(MyNoteViewController.editNote))
        noteListView.edite = false
        bottomButton.title = "划拉点啥"
        }else{
            navigationItem.rightBarButtonItem?.title = "取消"
            bottomButton.title = "不要这些"
            noteListView.edite = true
        }
    }
    //  MARK:--  noteDelegate
    func addNewNote(note: MyNote) {
        noteListView.notes.append(note)
        noteListView.reloadData()
    }

    //清理标记
    private  func clearSelected(){
        for cell in noteListView.visibleCells{
            (cell as!MyNoteCell).selectedMark.hidden = true
        }
    }
    //编辑笔记
    func editNote(){
        noteListView.edite = !noteListView.edite
        if noteListView.edite == false{
            setupUI()
            noteListView.reloadData()
        }else{
            setupUI()
            noteListView.reloadData()
            if noteListView.deleteNotes.count > 0 {
                clearSelected()
                noteListView.deleteNotes.removeAll()
            }
        }
    }
    //新增笔记/删除笔记
    @IBAction func newNote(sender: AnyObject) {
        if noteListView.edite == false{
        let vc = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
            vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        }else{
            if noteListView.deleteNotes.count > 0 {
                deleteNoteFromService(noteListView.deleteNotes)
                self.noteListView.edite = false
                self.setupUI()
            }else{
//                toast("请选择要删除的笔记")
                alert("请选择要删除的笔记")
            }
        }
    }
    //删除服务器数据
    func deleteNoteFromService(ids:[MyNote]?){
        var deIds:[String] = [String]()
        for delNote in ids!{
            for (index,note) in noteListView.notes.enumerate(){
                if delNote.id == note.id{
                    noteListView.notes.removeAtIndex(index)
                    deIds.append(delNote.id)
                }
            }
        }
        noteListView.reloadData()
        weak var weakSelf = self
        asyn_global {
           weakSelf!.deleteDatasInDB(deIds)
        }
    }
    
    
    func deleteDatasInDB(ids:[String]) {
        let DB = SQLiteManager.SQManager.DB
        DB?.open()
        
        for id in ids {
            
            let sqStr = "DELETE FROM T_MyNote WHERE id is '\(id)';"
            
            if (DB?.executeUpdate(sqStr, withArgumentsInArray: nil))! {
//                print("批量删除成功")
                }
            }
        DB?.close()
    }
}
