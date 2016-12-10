//
//  StoriesViewController.swift
//  LDL
//
//  Created by Bryan Summersett on 12/9/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit

struct Story {
  let name: String
  let docs: [URL]
  let audio: [URL]

  var description: String {
    return "\(docs.count) PDFs, \(audio.count) MP3s"
  }
}

class StoriesViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Make the cell self size
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  // MARK: - UITableViewDataSource

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
    cell.titleLabel.text = story.name
    cell.detailLabel.text = story.description

    return cell
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
      }.map { $0.url }
      let audio = subDir.filter { file, _ in
        return file.pathExtension == "mp3"
      }.map { $0.url }
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

  // MARK: Segue logic

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    assert(segue.identifier == "showStory")
    let storyVC = segue.destination as! StoryViewController
    storyVC.story = stories[tableView.indexPathForSelectedRow!.row]
  }
}
