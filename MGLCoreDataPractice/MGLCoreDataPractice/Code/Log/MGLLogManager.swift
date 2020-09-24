//
//  MGLLogManager.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import UIKit
import CoreData

class MGLLogManager: NSObject {
    
    private static let sharedInstance = MGLLogManager()
    
    var coreDataHelper: MGLCoreDataHelper!
    var model: MGLCrashLogModel?
    
    class var shared: MGLLogManager {
        return sharedInstance
    }
    
    init(coreDataHelper: MGLCoreDataHelper = MGLCoreDataHelper()) {
        self.coreDataHelper = coreDataHelper
        super.init()
        self.coreDataHelper.setupCoreData()
    }

    func handleSaveLog(data: String) {
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
                self?.handleSaveLog(data: logStr)
            }
        }
    }
    
    func storeCrashLog(data: String) {
        let model = NSEntityDescription.insertNewObject(forEntityName: "CrashLog", into: coreDataHelper.context) as? MGLCrashLogModel
        if let model = model {
            model.uuid = UUID().uuidString
            model.createDate = Date()
            model.crashLog = data
            model.userData = "test"
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

