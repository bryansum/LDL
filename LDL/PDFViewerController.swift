//
//  PDFViewerController.swift
//  LDL
//
//  Created by Bryan Summersett on 12/11/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import Foundation
import UIKit
import QuickLook

class PDFViewerController: UIViewController, QLPreviewControllerDataSource {

  let docs: [URL]
  let ql = QLPreviewController()

  var selected = 0 {
    didSet {
      ql.currentPreviewItemIndex = selected
    }
  }

  init(docs: [URL]) {
    self.docs = docs
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    addChildViewController(ql)
    ql.view.frame = view.bounds
    view.addSubview(ql.view)
    ql.didMove(toParentViewController: self)

    ql.dataSource = self
  }

  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    return docs.count
  }

  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    return docs[index] as QLPreviewItem
  }
}
