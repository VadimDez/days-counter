//
//  ViewController.swift
//  Days
//
//  Created by Vadim Dez on 18.09.17.
//  Copyright © 2017 Vadim Dez. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {

    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    var data: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData();
        
        self.updateLabel();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSuccess(_ sender: Any) {
        self.data.count = self.data.count + 1;
        self.saveData();
        self.updateLabel();
    }

    @IBAction func onReset(_ sender: Any) {
        self.data.count = 0;
//        self.saveData();
        self.updateLabel();
    }
    
    func updateLabel() -> Void {
        self.daysLabel.text = "\( self.data.count )";
    }
    
    private func saveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.data, toFile: Data.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadData() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: Data.ArchiveURL.path) as? Data {
            self.data = data;
        } else {
            self.data = Data(count: 0);
        }
    }
}

