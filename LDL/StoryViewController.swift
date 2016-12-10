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

  private let story: Story

  init(story: Story) {
    self.story = story
    super.init(style: .grouped)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = story.name

    tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: StoryTableViewCell.CellIdentifier)
    tableView.rowHeight = 44
  }

  // MARK: - UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch Sections(rawValue: section)! {
    case .docs:
      return "Documents"
    case .audio:
      return "Audio"
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Sections(rawValue: section)! {
    case .docs:
      return story.docs.count
    case .audio:
      return story.audio.count
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.CellIdentifier, for: indexPath) as! StoryTableViewCell

    switch Sections(rawValue: indexPath.section)! {
    case .docs:
      let doc = story.docs[indexPath.row]
      cell.textLabel?.text = doc.fileName
    case .audio:
      let audio = story.audio[indexPath.row]
      cell.textLabel?.text = audio.fileName
    }

    return cell
  }

}
