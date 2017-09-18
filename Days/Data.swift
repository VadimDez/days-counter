//
//  Data.swift
//  Days
//
//  Created by Vadim Dez on 18.09.17.
//  Copyright © 2017 Vadim Dez. All rights reserved.
//

import UIKit
import os.log

class Data: NSCoder {
    var count: UInt!
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("data")
    
    struct PropertyKey {
        static let count = "count";
    }
    
    init?(count: UInt) {
        self.count = count;
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let count = UInt(aDecoder.decodeInteger(forKey: PropertyKey.count))
        
        self.init(count: count);
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.count, forKey: PropertyKey.count)
    }
}
