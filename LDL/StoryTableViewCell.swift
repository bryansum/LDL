//
//  StoryTableViewCell.swift
//  LDL
//
//  Created by Bryan Summersett on 12/10/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit

class StoryTableViewCell: UITableViewCell {
  static let CellIdentifier = String(describing: StoryTableViewCell.self)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.textLabel?.adjustsFontSizeToFitWidth = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
