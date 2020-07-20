//
//  MainViewModel.swift
//  RailsTask
//
//  Created by Jimoh Babatunde  on 19/07/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

enum MainviewModelState {
    case MainViewDidFetchSuccessful
    case MainViewDidFetchFail
}

protocol MainViewModelDelegate: class {
    func MainViewModelDidChangeState(state: MainviewModelState)
}

class MainViewModel: NSObject, UITableViewDataSource {
    public weak var delegate:MainViewModelDelegate?
    public var recentCommit : [JSON] = []
    
    //MARK: Login
    public func login () {
        NetworkService.sharedManager.login(){(success, object, response) in
            if success {
                debugPrint(object)
        }
    }
}
    public func getRepo() {
        NetworkService.sharedManager.getRepo(owner: "rails", name: "rails") {
            (success, object, response) in
            if success {
                debugPrint(object)
            }
        }
    }
    
    public func getCommit() {
        NetworkService.sharedManager.getCommits(owner: "rails", name: "rails") {
            (success, object, response) in
            if success {
                DispatchQueue.main.async {
                    self.recentCommit = (object?["data"]["repository"]["defaultBranchRef"]["target"]["history"]["edges"].arrayValue)!
                    print(self.recentCommit.count)
                    
                    self.delegate?.MainViewModelDidChangeState(state: .MainViewDidFetchSuccessful)
               
                }
            }
        }
    }
    
    //MARK: Register TableView
   public func registerReusableViewsForTableView(tableView: UITableView) {
       //Register the custom tableview cells
       tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "recentCommentCell")
       tableView.dataSource = self
   }
   
   //MARK: UITableView Datasource
   func numberOfSections(in tableView: UITableView) -> Int {
       return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.recentCommit.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "recentCommentCell", for: indexPath) as? MainTableViewCell
    let recentCommits = self.recentCommit[indexPath.item]
    cell?.updateCell(recentCommit: recentCommits)
    return cell!
   }
}

