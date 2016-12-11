//
//  AudioPlayer.swift
//  LDL
//
//  Created by Bryan Summersett on 12/10/16.
//  Copyright © 2016 Bryan Summersett. All rights reserved.
//

import AVFoundation
import Foundation
import MediaPlayer
import UIKit

let audioPlayer = AudioPlayer()

class AudioPlayer: UIView {

  let audioPlayer = AVPlayer()
  var token: NSObjectProtocol!
  var observer: Any?

  let pauseButton = UIButton(type: .custom)
  let playButton = UIButton(type: .custom)
  let progressBar = UIProgressView(progressViewStyle: .bar)

  override init(frame: CGRect) {
    super.init(frame: frame)

    audioPlayer.actionAtItemEnd = .pause
    audioPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: nil)
    audioPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem), options: .new, context: nil)

    token = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] _ in
      self?.audioPlayer.seek(to: kCMTimeZero)
    }

    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    observer = audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] _ in
      guard
        let audioPlayer = self?.audioPlayer,
        let currentItem = audioPlayer.currentItem,
        !currentItem.duration.isIndefinite
        else {
          return
      }
      let currentTime = audioPlayer.currentTime().seconds
      let duration = currentItem.duration.seconds
      let progress = Float(currentTime / duration)
      self?.progressBar.progress = progress
    }

    pauseButton.setImage(#imageLiteral(resourceName: "PauseButton"), for: .normal)
    pauseButton.sizeToFit()
    pauseButton.isHidden = true
    pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
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
    audioPlayer.removeTimeObserver(observer!)
    audioPlayer.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
    NotificationCenter.default.removeObserver(token!)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK - Public methods

  func play(url: URL) {
    let asset = AVAsset(url: url)
    let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: [#keyPath(AVAsset.duration)])

    let mpic = MPNowPlayingInfoCenter.default()
    mpic.nowPlayingInfo = [
      MPMediaItemPropertyTitle: url.fileName,
      MPMediaItemPropertyArtist: "LDL",
      MPMediaItemPropertyPlaybackDuration: asset.duration.seconds,
      MPNowPlayingInfoPropertyMediaType: MPNowPlayingInfoMediaType.audio.rawValue
    ]

    audioPlayer.replaceCurrentItem(with: playerItem)
    audioPlayer.play()

    let mpcc = MPRemoteCommandCenter.shared()
    mpcc.playCommand.addTarget(self, action: #selector(play as (Void) -> Void))
    mpcc.pauseCommand.addTarget(self, action: #selector(pause))
  }

  func play() {
    audioPlayer.play()
  }

  func pause() {
    let mpic = MPNowPlayingInfoCenter.default()
    mpic.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime().seconds
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

      let mpic = MPNowPlayingInfoCenter.default()
      mpic.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = rate

    case #keyPath(AVPlayer.currentItem):
      resetTransport()
    default:
      break
    }
  }

  private func resetTransport() {
    let mpic = MPNowPlayingInfoCenter.default()
    mpic.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0
    progressBar.progress = 0
  }
}
