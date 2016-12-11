//
//  StoriesViewController.swift
//  LDL
//
//  Created by Bryan Summersett on 12/9/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit

class StoriesViewController: UITableViewController {

  init() {
    super.init(style: .plain)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Stories"

    tableView.register(StoriesTableViewCell.self, forCellReuseIdentifier: StoriesTableViewCell.CellIdentifier)
    tableView.rowHeight = 44
  }

  // MARK: - UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StoriesTableViewCell.CellIdentifier, for: indexPath) as! StoriesTableViewCell

    // Configure the cell...
    let story = stories[indexPath.row]
    cell.textLabel?.text = story.name
    cell.detailTextLabel?.text = story.description

    return cell
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let story = stories[indexPath.row]

    let storyVC = StoryViewController(story: story)

    navigationController?.pushViewController(storyVC, animated: true)
  }

  // MARK: Documents

  lazy var documentsDir: URL = {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }()

  lazy var stories: [Story] = {
    self.urls(in: self.documentsDir).filter { _, values in
      return values.isDirectory!
    }.map { dir, values in
      let name = values.name!
      let subDir = self.urls(in: dir)

      let docs = subDir.filter { file, _ in
        return file.pathExtension == "pdf"
      }
      .map { $0.url }
      .sorted {
        $0.fileName.localizedStandardCompare($1.fileName) == .orderedAscending
      }

      let audio = subDir.filter { file, _ in
        return file.pathExtension == "mp3"
      }
      .map { $0.url }
      .sorted {
        $0.fileName.localizedStandardCompare($1.fileName) == .orderedAscending
      }
      return Story(name: name, docs: docs, audio: audio)
    }
  }()

  typealias URLs = (url: URL, values: URLResourceValues)

  let directoryKeys: [URLResourceKey] = [.isDirectoryKey, .nameKey]

  func urls(in directory: URL) -> [URLs] {
    let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: directoryKeys, options: [.skipsSubdirectoryDescendants], errorHandler: nil)!

    var urls = [URLs]()

    for case let url as URL in enumerator {
      guard let resourceValues = try? url.resourceValues(forKeys: Set(directoryKeys)) else {
          continue
      }
      urls.append((url, resourceValues))
    }
    return urls
  }
}
