//
//  ViewController.swift
//  RailsTask
//
//  Created by Jimoh Babatunde  on 19/07/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, MainViewModelDelegate {
    
    
    private let viewModel = MainViewModel()
  
    @IBOutlet weak var tableview: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.tableview?.delegate = self
        viewModel.registerReusableViewsForTableView(tableView: tableview!)
        viewModel.login()
        viewModel.getRepo()
        viewModel.getCommit()
        
        // Do any additional setup after loading the view.
    }
    
    func MainViewModelDidChangeState(state: MainviewModelState) {
        switch state {
        case .MainViewDidFetchSuccessful:
            self.tableview?.reloadData()
        case .MainViewDidFetchFail:
            let confimationAlert = UIAlertController(title: "Unauthorised token", message: "Please generate a new pat on your github to have access github grapql server", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            confimationAlert.addAction(cancelAction)
            present(confimationAlert, animated: true, completion: nil)
                
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }


}


