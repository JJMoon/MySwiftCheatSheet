//
//  HtServerRequest.swift
//  Monitor
//
//  Created by Jongwoo Moon on 2016. 1. 5..
//  Copyright © 2016년 IMLab. All rights reserved.
//

import Foundation

class HtServerRequest : HtStopWatch {
    var logA = HtLog(cName: "HtServerRequest")

    var arrStudent: [HmStudent]?
    var timer = NSTimer()
    var timeOutSeconds: Double = 10 // 총 타임아웃 시간..
    var isWaiting = false // response 받는 동안..  기다림..
    var sendDataFinishedCljr: Void->Void = { Void->Void in }
    var liscenceErrorCallBack: Void->Void = { Void->Void in }
    var curStdt: HmStudent?
    var progress: HmDotProcess?, totalNum = 0

    override init() { super.init() }
    convenience init(interval: Double, theArray: [HmStudent]) {
        self.init()
        resetTime()
        arrStudent = theArray
        if 5 < arrStudent?.count { timeOutSeconds = Double((arrStudent?.count)!) * 2 }
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "update", userInfo: nil, repeats: true)
        totalNum = (arrStudent?.count)!
    }

    var isTimeOver: Bool { get {  return timeOutSeconds < timeSinceStart } } // 이걸로 타임아웃 결정

    ///  타이머 함수..
    func update() {
        if (arrStudent!.count == 0) { // 다 보냈으므로 종료 절차에 들어간다..
            finalJob()
            return
        }
        progress?.progress = 1.0 - CGFloat((arrStudent?.count)!) / CGFloat(totalNum) // 프로그레스 % 표시.
        if isWaiting { // 작업 중이면 skip
            logA.logThis("   Waiting  ....   student num :  \(arrStudent!.count)   progress \(progress?.progress)  ")
        } else {
            checkLicense() /// 작업을 개시함..
        }
    }


    func failedOrSuccessDropFirst() {
        logA.printThisFNC("failedOrSuccessDropFirst", comment: " 다 보냈는지 확인...   학생 수 :  \(arrStudent?.count) ")
        if 0 < arrStudent?.count { arrStudent?.removeFirst() }
        else { print ("  Zero !!!@@# ") }
        isWaiting = false
    }

    func checkLicense() {
        isWaiting = true
        self.logA.printAlways("  라이센스 가져오기 시작 ")
        HsCheckLicense.singltn.checkLicence( {
            licenseID = HsCheckLicense.singltn.result
            self.checkLicense후속작업()
            }, failureBlck: {
                self.isWaiting = false
                self.arrStudent?.removeAll() // 완전 취소....
                self.liscenceErrorCallBack() // 완전 종료 시킴....
        })
    }

    private func checkLicense후속작업() {
        logA.printThisFNC("checkLicense후속작업", comment: " 라이센스 : \(licenseID)")
        curStdt = arrStudent?.first


        addStudent(curStdt!)

        /// 아래는 서버에 확인 할 때 ...  버전이고...  지금은 일단 보낸다...

//        if 0 < curStdt!.svrID { // 학생은 등록 되었으니..  중간에 사고 났을 경우인데.. 굉장히 드물 것임...
//            sendData(curStdt!)
//        } else { // 일단 학생부터 등록하고..
//            addStudent(curStdt!)
//        }
    }

    private func addStudent(stdObj: HmStudent) {
        isWaiting = true
        self.logA.printAlways("  학생 서버에 등록 시작 ")
        HsAddStudentJobs.singltn.addStudentRequest(stdObj, successBlck: {
            self.log.printAlways("  학생 서버에 등록 OK   svrID : \(stdObj.svrID)")
            self.sendData(stdObj)
            },
            failureBlck:  {
                self.log.printAlways("  학생 등록 실패 ...  ", lnum: 20)
                self.failedOrSuccessDropFirst()
        })
    }

    private func sendData(stdObj: HmStudent) {
        isWaiting = true
        HsStudentDataJobs.singltn.sendDataRequest(stdObj, successBlck: {
            self.logA.printAlways("  학생 ___ 데이터 ___   서버에 등록 OK   ")
            self.updateStudentInfo(stdObj)
            self.failedOrSuccessDropFirst()
            }, failureBlck: {
                self.failedOrSuccessDropFirst()
                self.log.printAlways("  데이터 등록 실패 ...  ", lnum: 20)
        })
    }

    private func updateStudentInfo(curStd: HmStudent) {
        curStd.svrSaved = 1
        curStd.updateDatabase()
    }

    private func finalJob() {
        HsBleMaestr.inst.deleteServerSentStudents() // 데이터베이스 삭제..
        timer.invalidate()
        sendDataFinishedCljr()
    }

}