//
//  UINavigationController+ToolBar.swift
//  LDL
//
//  Created by Bryan Summersett on 12/10/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
  var audioPlayer: AudioPlayer {
    return toolbarItems!.first!.customView as! AudioPlayer
  }

  func play(url: URL) {
    if isToolbarHidden {
      setToolbarHidden(false, animated: true)
    }
    audioPlayer.play(url: url)
  }
}
