//
//  MGLLogViewModelProtocol.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import RxSwift

protocol MGLLogViewModelProtocol {
    
    var saveLogResult: Observable<MGLResult> { get }
    var errorResult: Observable<Error> { get }
    
    func saveLog(data: String)
}
