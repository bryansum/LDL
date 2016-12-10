//
//  StoryViewController.swift
//  LDL
//
//  Created by Bryan Summersett on 12/9/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import AVKit
import Foundation
import UIKit

class StoryViewController: UITableViewController {

  enum Sections: Int {
    case docs, audio
  }

  var story: Story!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = story.name

    
  }

  // MARK: - UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Sections(rawValue: section) {
    case .some(.docs):
      return story.docs.count
    case .some(.audio):
      return story.audio.count
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as! StoryTableViewCell

    // Configure the cell...
    let story = stories[indexPath.row]
    cell.titleLabel.text = story.name
    cell.detailLabel.text = story.description

    return cell
  }

}
