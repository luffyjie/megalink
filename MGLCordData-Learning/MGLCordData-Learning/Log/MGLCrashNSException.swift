//
//  MGLCrashNSException.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import UIKit

func registerUncaughtExceptionHandler() {
    NSSetUncaughtExceptionHandler(uncaughtExceptionHandler)
}

func uncaughtExceptionHandler(exception: NSException) {
    let arr = exception.callStackSymbols
    let reason = exception.reason
    let name = exception.name.rawValue
    var crash = String()
    crash += "Stack:\n"
    crash = crash.appendingFormat("slideAdress:0x%0x\r\n", calculate())
    crash += "\r\n\r\n name:\(name) \r\n reason:\(String(describing: reason)) \r\n \(arr.joined(separator: "\r\n")) \r\n\r\n"
    MGLLogManager.shared.storeCrashLog(data: crash)
}
