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
        self.register(UITableViewCell.self, forCellReuseIdentifier: identFier)
        let actionModel = ActionModel()
        ActionArray = actionModel.modelArray
        self.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActionArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identFier, for: indexPath)
        let model = ActionArray[indexPath.row]
        cell.textLabel?.text = model.ActionName
        cell.textLabel?.textColor = UIColor.green
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.contentView.superview?.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let vcClass = (ActionArray[indexPath.row].ActionVc) as! UIViewController.Type
        let vc = vcClass.init()
        vc.hidesBottomBarWhenPushed = true
        guard let parentVc = UIView.getSelfController(self)else{return false}
        (parentVc.navigationController as! CustomAnimaViewNavigation).pushViewController(vc, Rect: CGRect(origin: parentVc.view.center, size: CGSize.zero), animated: true)
        return false
    }
}
