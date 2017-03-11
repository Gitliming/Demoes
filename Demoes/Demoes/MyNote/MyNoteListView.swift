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
    
    var notes = [MyNote]()
    
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
        tableFooterView = UIView.spliteLine(10)
        rowHeight = 60
        dataSource = self
        delegate = self
//        addRefreshControl()
    }
    // MARK: 获取笔记列表
    func getNoteList(isfresh:Bool = true){
        
        var begin = 0
        if isfresh{
            begin = 0
        }else{
            begin = self.notes.count
        }
//        guard let _ = Utils.getUser()else{
//            alert("请登陆后查看！")
//            self.endRefreshing()
            self.finishedRefresh()
            return
        }
//        api.getNoteList.get(["start":begin, "limit":10], callback: { (response:LDApiResponse<PageResult<MyNote>>) in
//            
//            response.success({ (msg) in
//                Log.debug(msg)
//                self.total = msg.total
//                self.endRefreshing()
//                self.finishedRefresh()
//                
//                if isfresh{
//                     self.notes = msg.list
//                }else{
//                    self.notes  = self.notes + msg.list
//                }
//                self.reloadData()
//            })
//            response.failure({ (error) in
//                toast("请求失败")
//                self.endRefreshing()
//                self.finishedRefresh()
//            })
//        })
//    }
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
            toShowNote(note)
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
            guard let vc = UIView.getSelfController(self)else{return}
            (vc as? MyNoteViewController)?.deleteNoteFromService([note.id])
        }
    }
    //MARK:-- MJTableViewRefreshDelegate
//    func tableView(tableView: LDTableView, refreshDataWithType refreshType: LDTableView.RefreshType) {
//        
//        self.getNoteList(refreshType == .Header)
//    }
    
    //MARK:------添加 刷新
//    func addRefreshControl(){
//        noDataNotice = "没有笔记"
//        self.noDataImageYOffset = UIScreen.mainScreen().bounds.height / 12
//       
//        refreshData()
//        refreshTableDelegate = self
//        configRefreshable(headerEnabled: true, footerEnabled: true)
//        mj_header.beginRefreshing()
//    }
    func toShowNote(note:MyNote){
        let vc = NoteShowViewController(nibName: "NewNoteViewController", bundle: nil)
        vc.noteModel = note
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
