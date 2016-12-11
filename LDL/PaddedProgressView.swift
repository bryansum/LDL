//
//  PaddedProgressView.swift
//  LDL
//
//  Created by Bryan Summersett on 12/12/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit

class PaddedProgressView: UIProgressView {

  init(paddingY: Float) {
    self.paddingY = CGFloat(paddingY)
    super.init(frame: .zero)
    progressViewStyle = .bar
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var paddingY: CGFloat

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let extendedBounds = bounds.insetBy(dx: 0, dy: -paddingY)
    return extendedBounds.contains(point)
  }
}
