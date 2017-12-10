//
//  MomentViewController.swift
//  PerfectiOS
//
//  Created by swae on 2017/12/10.
//  Copyright © 2017年 swae. All rights reserved.
//

import UIKit

class MomentViewController: UIViewController {
    
    var momentList: [Moment] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self as UITableViewDataSource
        tableView.delegate = self as UITableViewDelegate
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "momentCellID")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        queryMomentList()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        let views = ["tableView": tableView]
       let constraintArrayH = NSLayoutConstraint.constraints(withVisualFormat: "|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        let constraintArrayV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        NSLayoutConstraint.activate(constraintArrayH)
        NSLayoutConstraint.activate(constraintArrayV)
    }
    
    private func queryMomentList() {
        guard let user = AccountManager.shared.loginUser else {
            print("用户未登录")
            self.errorNotice("未找到登录的用户")
            return
        }
        MomentAPI.shared.queryMomentList(userId: user.userId) { (response, error) in
            guard (error == nil) else {
                self.errorNotice("查询moment失败")
                return
            }
            
            guard let list = response else {
                print("无moment")
                return
            }
            
            self.momentList = list as! [Moment]
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MomentViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return momentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "momentCellID", for: indexPath)
        
        let moment = momentList[indexPath.row]
        
        cell.textLabel?.text = moment.title
        cell.detailTextLabel?.text = moment.content
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}
