//
//  MainTableViewCell.swift
//  RailsTask
//
//  Created by Jimoh Babatunde  on 19/07/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainTableViewCell: UITableViewCell {
    
   @IBOutlet weak var commitMessage: UILabel?
   @IBOutlet weak var authorName: UILabel?
   @IBOutlet weak var commitDate: UILabel?
       
   override func awakeFromNib() {
       super.awakeFromNib()
       // Initialization code
   }

   override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)

       // Configure the view for the selected state
   }
   
   public func updateCell(recentCommit: JSON) {
       self.commitMessage?.text = recentCommit["node"]["message"].stringValue
       self.authorName?.text = recentCommit["node"]["author"]["name"].stringValue
       self.commitDate?.text = recentCommit["node"]["committedDate"].stringValue
       
   }
    
}
