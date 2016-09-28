//
//  HtAudioPlayer.swift
//  Trainer
//
//  Created by Jongwoo Moon on 2016. 1. 27..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation
import AVFoundation

class HtAudioPlayer: NSObject {
    var log = HtLog(cName: "HtAudioPlayer")
    var counter = 0, pausing = false, repeatLmt = 1 // 기본은 한번만..
    var aURL : NSURL?
    var cntTimer: NSTimer?, interval = 60.0 / 100.0
    private var player: AVAudioPlayer?
    private var players = [AVAudioPlayer](), arrNum = 7, sequenceIdx = 0
    private var isMuteOn = false

    var playing: Bool { get { return (player?.playing)! } }

    //var isPlaying: Bool { get { return (player?.isPlaying)! } }

    convenience init(repeatLimit: Int, url: NSURL, initMuteOn: Bool) {
        self.init()
        aURL = url
        isMuteOn = initMuteOn
        repeatLmt = repeatLimit
        do {
            try player = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("  AV Player Creation Error !!!!!  \(url)  ")
        }
        applyMute()
    }

    deinit {
        cntTimer?.invalidate()
    }

    //////////////////////////////////////////////////////////////////////       [ UI Sub  ]
    // Interval Variation
    func initTimer(intervalOfTimer: Double) {
        //log.printThisFunc("initTimer(intervalOfTimer: Double)", lnum: 1)
        if 1 < intervalOfTimer {
            interval = intervalOfTimer
        } else {
            interval = 5
        }
        playerArraySet()
        resetTimer()
        player?.stop()
        cntTimer = NSTimer.scheduledTimerWithTimeInterval(60.0 / interval, // second
            target:self, selector: #selector(HtAudioPlayer.update), userInfo: nil, repeats: true)
        applyMute()
    }

    private func playerArraySet() {
        //print("     playerArraySet()")
        // for pler in players {            pler.stop()        }

        players = [AVAudioPlayer]()

        for _ in 0..<arrNum {
            do {
                try players.append(AVAudioPlayer(contentsOfURL: aURL!))
            } catch {
                print("  AV Player Creation Error !!!!!  \(aURL)  ")
            }
        }
        applyMute()
    }

    func update() {
        //log.printAlways("audio update .>>>>  \(aURL)  sequenceIdx : \(sequenceIdx)  *****   >>>>>> ", lnum: 1)
        if pausing { return }
        if (sequenceIdx == arrNum) { sequenceIdx = 0 }

        players[sequenceIdx].play()

        sequenceIdx += 1
    }

    func pauseTimer() {
        print("\n  audio Timer .>>>>  \(aURL)   *****   >>>>>>   pauseTimer \n")
        if pausing { return } // 현재 정지 중...
        pausing = true
        applyMute()
    }

    func unpuaseTimer() {
        print("\n  audio Timer .>>>>  \(aURL)   *****   >>>>>>   unpauseTimer \n")
        pausing = false
        applyMute()
    }

    private func resetTimer() {
        print("\n  audio Timer .>>>>  \(aURL)   *****   >>>>>>   resetTimer() \n")
        if cntTimer != nil {
            cntTimer?.invalidate()
            cntTimer = nil
        }
        applyMute()
    }

    /// 멈춤. 타이머도 동시에..
    func stop() {
        print("  HtAudioPlayer :: stop  \(cntTimer)")
        //print("\n  audio Timer .>>>>  \(aURL)   *****   >>>>>>   stop \n")
        player?.stop()
        cntTimer?.invalidate()
        resetTimer()
    }

    /// 뮤트 관련...

    func muteOnOff(isOn: Bool) {
        isMuteOn = isOn
        applyMute()
    }

    /// 오디오 컨트롤 할 때마다 볼륨 조절..
    private func applyMute() {
        if (isMuteOn) {
            setVolume(0)
        } else {
            setVolume(1.0)
        }
    }
    private func setVolume(vol : Float) {
        player?.volume = vol
        for av in players {
            av.volume = vol
        }
    }


    /// Not use Timer...
    func reset() {
        resetCount()
        player?.stop()
        player = nil
        pausing = false
    }

    func resetCount() {
        counter = 0
    }

    func pause() {
        if pausing { return } // 현재 정지 중...
        if player?.playing == true { // 재생을 다 한 상태면 pause 가 아니라 play를 해야 함..
            player?.pause()
            pausing = true
        }
    }

    func unpause() {
        if pausing {
            if 0 == players.count {
                player?.play() // 재 시작..
            }
            pausing = false
        }
        //print(" un puase ")
    }


    func play() -> Bool {
        pausing = false
        var rval = false
        if counter <= repeatLmt || repeatLmt == -1 { rval = player!.play()  }
        counter += 1
        return rval // 플레이가 안되면 false 리턴.
    }
}