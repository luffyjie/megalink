//
//  MGLCrashLogModel.swift
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

import CoreData

@objc(MGLCrashLogModel)
class MGLCrashLogModel: NSManagedObject {
    
    @NSManaged public var uuid: String?
    @NSManaged public var crashLog: String?
    @NSManaged public var userData: String?
    @NSManaged public var createDate: Date?
}

@objc(MGLAppVersionLogModel)
class MGLAppVersionLogModel: NSManagedObject {
    
    @NSManaged public var uuid: String?
    @NSManaged public var displayCount: NSNumber?
    @NSManaged public var lastDisplayTime: Date?
}
