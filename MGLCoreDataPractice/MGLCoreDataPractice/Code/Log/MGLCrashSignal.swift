//
//  MGLCrashSignal.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import UIKit

func signalExceptionHandler(signal:Int32) -> Void {
    var mstr = String()
    mstr += "Stack:\n"
    mstr = mstr.appendingFormat("slideAdress:0x%0x\r\n", calculate())
    for symbol in Thread.callStackSymbols {
        mstr = mstr.appendingFormat("%@\r\n", symbol)
    }
    MGLLogManager.shared.storeCrashLog(data: mstr)
    exit(signal)
}

func registerSignalHandler() {
    signal(SIGABRT, signalExceptionHandler)
    signal(SIGSEGV, signalExceptionHandler)
    signal(SIGBUS, signalExceptionHandler)
    signal(SIGTRAP, signalExceptionHandler)
    signal(SIGILL, signalExceptionHandler)
}
