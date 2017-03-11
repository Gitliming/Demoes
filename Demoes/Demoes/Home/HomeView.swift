//
//  HomeView.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/13.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class HomeView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    let identFier = "HomeViewCell"
    var ActionArray = [Model]()
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setting()
    }
    
    func setting(){
        dataSource = self
        delegate = self
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: identFier)
        let actionModel = ActionModel()
        ActionArray = actionModel.modelArray
        self.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActionArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identFier, forIndexPath: indexPath)
        let model = ActionArray[indexPath.row]
        cell.textLabel?.text = model.ActionName
        cell.textLabel?.textColor = UIColor.greenColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.contentView.superview?.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let vcClass = (ActionArray[indexPath.row].ActionVc) as! UIViewController.Type
        let vc = vcClass.init()
        guard let parentVc = UIView.getSelfController(self)else{return false}
        (parentVc.navigationController as! CustomAnimaViewNavigation).pushViewController(vc, Rect: CGRect(origin: parentVc.view.center, size: CGSizeZero), animated: true)
        return false
    }
}
