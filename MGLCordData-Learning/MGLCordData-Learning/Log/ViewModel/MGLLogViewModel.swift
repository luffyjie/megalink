//
//  MGLLogViewModel.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MGLLogViewModel: MGLLogViewModelProtocol {
    
    private let logHandler: MGLLogHandlerProtocol
    private let disposeBag = DisposeBag()
    
    var saveLogResult: Observable<MGLResult>
    var errorResult: Observable<Error>
    
    private let saveLogResultSubject = PublishSubject<MGLResult>()
    private let errorResultSubject = PublishSubject<Error>()
    
    init(witLogHandler logHandler: MGLLogHandlerProtocol = MGLLogHandler()) {
        self.logHandler = logHandler
        self.saveLogResult = saveLogResultSubject.asObservable()
        self.errorResult = errorResultSubject.asObservable()
    }
    
    func saveLog(data: String) {
        logHandler
            .saveLog(data: data)
            .subscribe(onNext: { [weak self] result in
                self?.saveLogResultSubject.onNext(result)
                }, onError: { [weak self] error in
                    self?.errorResultSubject.onNext(error)
            }).disposed(by: disposeBag)
    }
}
