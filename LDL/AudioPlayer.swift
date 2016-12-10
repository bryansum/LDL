//
//  AudioPlayer.swift
//  LDL
//
//  Created by Bryan Summersett on 12/10/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

let audioPlayer = AudioPlayer()

class AudioPlayer: UIView {

  let audioPlayer = AVPlayer()
  var observer: Any!
  var token: NSObjectProtocol!

  let pauseButton = UIButton(type: .custom)
  let playButton = UIButton(type: .custom)
  let progressBar = UIProgressView(progressViewStyle: .bar)

  override init(frame: CGRect) {
    super.init(frame: frame)

    audioPlayer.actionAtItemEnd = .pause
    audioPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: nil)
    audioPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem), options: .new, context: nil)

    let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    observer = audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] _ in
      guard
        let audioPlayer = self?.audioPlayer,
        let currentItem = audioPlayer.currentItem,
        currentItem.duration.isValid
      else {
        return
      }
      let currentTime = audioPlayer.currentTime().seconds
      let duration = currentItem.duration.seconds
      self?.progressBar.progress = Float(currentTime / duration)
    }

    token = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] _ in
      self?.audioPlayer.seek(to: kCMTimeZero)
    }

    pauseButton.setImage(#imageLiteral(resourceName: "PauseButton"), for: .normal)
    pauseButton.sizeToFit()
    pauseButton.isHidden = true
    addSubview(pauseButton)

    pauseButton.translatesAutoresizingMaskIntoConstraints = false
    pauseButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
    pauseButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    playButton.setImage(#imageLiteral(resourceName: "PlayButton"), for: .normal)
    playButton.sizeToFit()
    playButton.addTarget(self, action: #selector(play as (Void) -> Void), for: .touchUpInside)
    addSubview(playButton)

    playButton.translatesAutoresizingMaskIntoConstraints = false
    playButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
    playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    addSubview(progressBar)
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    progressBar.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8).isActive = true
    progressBar.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
    progressBar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }

  deinit {
    audioPlayer.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
    audioPlayer.removeTimeObserver(observer!)
    NotificationCenter.default.removeObserver(token!)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK - Public methods

  func play(url: URL) {
    let playerItem = AVPlayerItem(url: url)
    audioPlayer.replaceCurrentItem(with: playerItem)
    audioPlayer.play()
  }

  func play() {
    audioPlayer.play()
  }

  func pause() {
    audioPlayer.pause()
  }

  // MARK - Private methods

  enum PlayState {
    case paused
    case playing
  }

  var playState: PlayState = .paused {
    didSet {
      switch playState {
      case .paused:
        pauseButton.isHidden = true
        playButton.isHidden = false
      case .playing:
        pauseButton.isHidden = false
        playButton.isHidden = true
      }
    }
  }

  // MARK: - KVO

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    switch keyPath! {
    case #keyPath(AVPlayer.rate):
      guard let rate = change?[.newKey] as? Float else {
        return
      }
      playState = rate > 0 ? .playing : .paused
    case #keyPath(AVPlayer.currentItem):
      resetTransport()
    default:
      break
    }
  }

  private func resetTransport() {
    progressBar.progress = 0
  }
}
