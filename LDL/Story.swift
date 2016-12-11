//
//  Story.swift
//  LDL
//
//  Created by Bryan Summersett on 12/10/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation

struct Story {
  let name: String
  let docs: [URL]
  let audio: [URL]

  var description: String {
    return "\(docs.count) PDFs, \(audio.count) MP3s"
  }
}

extension URL {
  var fileName: String {
    return deletingPathExtension()
      .lastPathComponent
      .replacingOccurrences(of: "_Leicht-Deutsch-Lernen", with: "")
      .replacingOccurrences(of: ".com", with: "")
      .replacingOccurrences(of: "_German-Vocabulary", with: "")
  }
}
