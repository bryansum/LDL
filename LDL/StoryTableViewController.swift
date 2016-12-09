//
//  StoryTableViewController.swift
//  LDL
//
//  Created by Bryan Summersett on 12/9/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit

class StoryTableViewController: UITableViewController {

  let stories = ["Title1", "Title2"]

  override func viewDidLoad() {
    super.viewDidLoad()

    // Make the cell self size
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as! StoryTableViewCell

    // Configure the cell...
    let story = stories[indexPath.row]
    cell.titleLabel.text = story

    return cell
  }
}
