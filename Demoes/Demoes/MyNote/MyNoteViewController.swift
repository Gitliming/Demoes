//
//  MyNoteViewController.swift
//  aha
//
//  Created by xpming on 16/9/2.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit

class MyNoteViewController: UIViewController {
    
    @IBOutlet weak var noteNumber: UIBarButtonItem!
    @IBOutlet weak var noteListView: MyNoteListView!
    @IBOutlet weak var bottomButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: getLocString("edit"), style: .Plain, target: self, action: #selector(MyNoteViewController.editNote))
        noteListView.edite = false
        bottomButton.title = "＋ 新增笔记"
        }else{
            navigationItem.rightBarButtonItem?.title = "取消"
            bottomButton.title = "删除选中"
            noteListView.edite = true
        }
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
        let vc = UIViewController()//NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        }else{
            if noteListView.deleteNotes.count > 0 {
                
                var ids = [String]()
                
                for note in noteListView.deleteNotes{
                    ids.append(note.id)
                }
                deleteNoteFromService(ids)
               
                
                for delNote in noteListView.deleteNotes{
                    for (index,note) in noteListView.notes.enumerate(){
                        if delNote.id == note.id{
                            noteListView.notes.removeAtIndex(index)
                        }
                    }
                }
                noteListView.deleteNotes.removeAll()
            }else{
//                toast("请选择要删除的笔记")
            }
        }
    }
    //删除服务器数据
    func deleteNoteFromService(ids:[String]?){
//        api.manageNote.delete(["id":ids!]) { (response:LDApiResponse<MyNote>) in
//            response.success({ (msg) in
                self.noteListView.edite = false
                self.noteListView.reloadData()
                self.setupUI()
                self.noteListView.total -= ids!.count
//            })
//        }
    }

    func toShowNote(notifi:NSNotification){
        let vc = NoteShowViewController(nibName: "NewNoteViewController", bundle: nil)
        vc.noteModel = notifi.object as? MyNote
        navigationController?.pushViewController(vc, animated: true)
    }
}
