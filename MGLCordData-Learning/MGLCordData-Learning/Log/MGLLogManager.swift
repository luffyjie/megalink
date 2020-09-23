//
//  MGLLogManager.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import UIKit
import RxSwift
import CoreData

class MGLLogManager: NSObject {
    
    private static let sharedInstance = MGLLogManager()
    
    private let disposeBag = DisposeBag()
    var viewModel: MGLLogViewModelProtocol!
    var coreDataHelper: MGLCoreDataHelper!
    var model: MGLCrashLogModel?
    
    class var shared: MGLLogManager {
        return sharedInstance
    }
    
    init(viewModel: MGLLogViewModelProtocol = MGLLogViewModel(), coreDataHelper: MGLCoreDataHelper = MGLCoreDataHelper()) {
        self.viewModel = viewModel
        self.coreDataHelper = coreDataHelper
        super.init()
        self.coreDataHelper.setupCoreData()
        self.setupViewModel()
    }
    
    func setupViewModel() {
        viewModel.saveLogResult
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .subscribe(onNext: { [weak self] result in
                self?.handleSaveLogResult(result: result)
            }).disposed(by: disposeBag)
    }
    
    func handleSaveLogResult(result: MGLResult) {
        if let model = model {
            coreDataHelper.context.delete(model)
            coreDataHelper.saveContext()
            uploadCrashLog()
        }
    }
    
    func register() {
        registerSignalHandler()
        registerUncaughtExceptionHandler()
    }
    
    func uploadCrashLog() {
        DispatchQueue.global().async { [weak self] in
            let request = NSFetchRequest<MGLCrashLogModel>(entityName: "CrashLog")
            let list =  try? self?.coreDataHelper.context.fetch(request)
            self?.model = list?.first
            if let model = self?.model {
                let logStr = (model.userData ?? "") + (model.crashLog ?? "")
                self?.viewModel.saveLog(data: logStr)
            }
        }
    }
    
    func storeCrashLog(data: String) {
        let model = NSEntityDescription.insertNewObject(forEntityName: "CrashLog", into: coreDataHelper.context) as? MGLCrashLogModel
        if let model = model {
            model.uuid = UUID().uuidString
            model.createDate = Date()
            model.crashLog = data
            var parameters = MGLNetwork.commonParameters()
            parameters["token"] = nil
            parameters["userId"] = nil
            parameters["pushClientId"] = nil
            model.userData = parameters.description
            coreDataHelper.saveContext()
        }
    }
    
    func storeAppVersionLog(data: String) {
        let model = NSEntityDescription.insertNewObject(forEntityName: "AppVersion", into: coreDataHelper.context) as? MGLAppVersionLogModel
        if let model = model {
            model.lastDisplayTime = Date()
            model.displayCount = 1
            model.uuid = data
            coreDataHelper.saveContext()
        }
    }
}

