//
//  Data.swift
//  Days
//
//  Created by Vadim Dez on 18.09.17.
//  Copyright © 2017 Vadim Dez. All rights reserved.
//

import UIKit
import os.log

class Data: NSObject, NSCoding {
    var count: UInt!
    var lastSuccessUpdate: Date!
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("data")
    
    struct PropertyKey {
        static let count = "count";
        static let lastSuccessUpdate = "updated";
    }
    
    init?(count: UInt = 0, lastSuccessUpdate: Date?) {
        self.count = count;
        self.lastSuccessUpdate = lastSuccessUpdate;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.count, forKey: PropertyKey.count)
        aCoder.encode(self.lastSuccessUpdate, forKey: PropertyKey.lastSuccessUpdate)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let count = aDecoder.decodeObject(forKey: PropertyKey.count) as! UInt
        guard let lastSuccessUpdate = aDecoder.decodeObject(forKey: PropertyKey.lastSuccessUpdate) as? Date else {
            return nil;
        }
        
        self.init(count: count, lastSuccessUpdate: lastSuccessUpdate);
    }
    
    func reset() -> Void {
        self.count = 0;
        self.lastSuccessUpdate = nil;
    }
}
