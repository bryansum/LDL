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

  func play(url: URL) {
    if isToolbarHidden {
      setToolbarHidden(false, animated: true)
    }
    audioPlayer.play(url: url)
  }
}
