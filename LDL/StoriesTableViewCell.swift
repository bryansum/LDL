//
//  StoriesTableViewCell.swift
//  LDL
//
//  Created by Bryan Summersett on 12/9/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit

class StoriesTableViewCell: UITableViewCell {
  static let CellIdentifier = String(describing: StoriesTableViewCell.self)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    accessoryType = .disclosureIndicator
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
