//
//  MyNoteListView.swift
//  aha
//
//  Created by xpming on 16/9/2.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import UIKit
class MyNoteListView: UITableView,/*,MJTableViewRefreshDelegate,*/ UITableViewDataSource, UITableViewDelegate {
    var total = 0 {
        didSet{
            guard let vc = UIView.getSelfController(self)else{return}
            (vc as? MyNoteViewController)?.noteNumber.title = "\(total)个笔记"
        }}
    
    var notes = [MyNote](){
        didSet{
        total = notes.count
        if total == 0{
            alert(massage: "没有笔记")
            }
        }
    }
    
    var deleteNotes = [MyNote]()
    
    var edite:Bool = false{
        didSet{
            if !edite{
                self.deleteNotes.removeAll()
            }
        }
    }

    var refreshFooter:UIActivityIndicatorView?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerNib(UINib(nibName:notecell, bundle: nil), forCellReuseIdentifier: notecell)
        tableFooterView = UIView.spliteLine(15)
        rowHeight = 60
        dataSource = self
        delegate = self
//        addRefreshControl()
    }
    
    
    // MARK: 获取笔记列表
    func getNoteList(isfresh:Bool = true){
        let DB = SQLiteManager.SQManager.DB
        DB?.open()
        guard let result = DB?.executeQuery("SELECT id, title, desc, creatTime FROM T_MyNote;", withArgumentsInArray: nil) else {print("取出失败")
            return}
        while result.next() {
            let id = result.stringForColumn("id")
            let title = result.stringForColumn("title")
            let desc = result.stringForColumn("desc")
            let creatTime = result.stringForColumn("creatTime")
            let note = MyNote(id: id, title: title, desc: desc, createTime: creatTime)
            notes.append(note)
            reloadData()
        }
        DB?.close()
        var begin = 0
        if isfresh{
            begin = 0
        }else{
            begin = self.notes.count
        }
        
            self.finishedRefresh()
            return
        }
    
    
    // MARK:-- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(notecell, forIndexPath: indexPath) as! MyNoteCell
        
        cell.isEditingStatus = self.edite
        let note = notes[indexPath.row]
        cell.noteModel = note
        
        if edite{
            var isExit = false
            for del in deleteNotes{
                if note.id == del.id{
                    isExit = true
                }
            }
            cell.isSelectedStatus = isExit
        }
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let note = notes[indexPath.row]
        if !edite{
            toShowNote(note, noteIndexPath: indexPath)
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MyNoteCell
        cell.isSelectedStatus = !cell.isSelectedStatus
        
                if cell.isSelectedStatus{
            var isExit = false
            for del in deleteNotes{
                if note.id == del.id{
                    isExit = true
                }
            }
            if !isExit{
                deleteNotes.append(note)
            }
        }
        else{
            for (index,del) in deleteNotes.enumerate(){
                if note.id == del.id{
                    deleteNotes.removeAtIndex(index)
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return !edite
    }
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete{
            let note = notes[indexPath.row]
            self.notes.removeAtIndex(indexPath.row)
            for (index,data) in deleteNotes.enumerate(){
                
                if note.id == data.id{
                    self.deleteNotes.removeAtIndex(index)
                    break
                }
            }

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            
            asyn_global({ 
               weakSelf(self)!.deleteSignleDataInDB(note.id)
            })
        }
    }
    
    
    func deleteSignleDataInDB(id:String){
        let DB = SQLiteManager.SQManager.DB
        
        DB?.open()
        
        let sqStr = "DELETE FROM T_MyNote WHERE id = '\(id)'"
        
        if DB!.executeUpdate(sqStr, withArgumentsInArray: nil){
        
            print("删除成功")
        }
        
        DB?.close()
    }
    
    
    func toShowNote(note:MyNote, noteIndexPath:NSIndexPath){
        let vc = NoteShowViewController(nibName: "NewNoteViewController", bundle: nil)
        vc.noteModel = note
        vc.noteIndexPath = noteIndexPath
        guard let VC = UIView.getSelfController(self)else{return}
        (VC as! MyNoteViewController).navigationController?.pushViewController(vc, animated: true)
    }

    
    //补充上拉刷新
    func bottomRefresh(){
         refreshFooter = UIActivityIndicatorView(frame: CGRect(x: (bounds.width - 44)/2, y: bounds.height - 50, width: 44, height: 44))
        refreshFooter!.color = UIColor.lightGrayColor()
        addSubview(refreshFooter!)
        refreshFooter!.startAnimating()
            getNoteList(false)
    }
    
    
    func finishedRefresh(){
        UIView.animateWithDuration(1.0) {
            self.refreshFooter?.stopAnimating()
            self.refreshFooter?.removeFromSuperview()
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentSize.height > scrollView.frame.size.height{
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + 60{
           bottomRefresh()
            }
        }else{
            if scrollView.contentOffset.y >= 60{
                bottomRefresh()
            }
        }
    }
}
