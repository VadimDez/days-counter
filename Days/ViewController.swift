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
    let dayInterval = 24 * 60 * 60;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData();
        self.update();
        
        self.resetInterval();
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSuccess(_ sender: Any) {
        self.data.count = self.data.count + 1;
        self.data.lastSuccessUpdate = Date.init();
        self.enableButtonAfterInterval(timeInterval: TimeInterval(self.dayInterval));
        self.saveData();
        self.update();
    }

    @IBAction func onReset(_ sender: Any) {
        self.data.reset();
        self.saveData();
        self.update();
    }
    
    func updateLabel() -> Void {
        self.daysLabel.text = "\( self.data.count! )";
    }
    
    func updateButton() -> Void {
        self.successButton.isEnabled = self.data.lastSuccessUpdate == nil || self.data.lastSuccessUpdate.addingTimeInterval(TimeInterval(self.dayInterval)) <= Date.init();
    }
    
    func update() {
        self.updateLabel();
        self.updateButton();
    }
    
    func enableButtonAfterInterval(timeInterval: TimeInterval) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(ViewController.updateButton), userInfo: nil, repeats: false)
    }
    
    private func saveData() {
        NSKeyedArchiver.archiveRootObject(self.data, toFile: Data.ArchiveURL.path)
    }
    
    private func loadData() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: Data.ArchiveURL.path) as? Data {
            self.data = data;
        } else {
            self.data = Data(count: 0, lastSuccessUpdate: nil);
        }
    }
    
    private func getRemainingTime() -> Int {
        let requestedComponent: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let timeDifference = Calendar.current.dateComponents(requestedComponent, from: self.data.lastSuccessUpdate, to: Date.init())
        
        return timeDifference.second!
            + timeDifference.minute! * 60
            + timeDifference.hour! * 3600
            + timeDifference.day! * 86400
    }
    
    
    func resetInterval() {
        let diff = self.dayInterval - self.getRemainingTime();
        
        if diff > 0 {
            self.enableButtonAfterInterval(timeInterval: TimeInterval(diff));
        }
    }
}

