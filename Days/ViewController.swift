//
//  ViewController.swift
//  Days
//
//  Created by Vadim Dez on 18.09.17.
//  Copyright © 2017 Vadim Dez. All rights reserved.
//

import UIKit
import UserNotifications

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
        self.initNotifications();
        
        self.daysLabel.textColor = UIColor.black;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSuccess(_ sender: Any) {
        self.data.count = self.data.count + UInt(1);
        self.data.lastSuccessUpdate = Date.init();
        self.enableButtonAfterInterval(timeInterval: TimeInterval(self.dayInterval));
        self.saveData();
        self.update();
    }

    @IBAction func onReset(_ sender: Any) {
        let alert = UIAlertController(title: "Reset", message: "Are you sure you want to reset counter?", preferredStyle: .alert);
        
        let sureAction = UIAlertAction(title: "Sure!", style: .default) { (action) in
            self.reset();
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func reset() -> Void {
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
        self.animateBefore { (_) in
            self.updateLabel();
        }
        self.updateButton();
    }
    
    func animateBefore(completion: @escaping (Bool) -> Void) -> Void {
        UIView.animate(withDuration: 2, animations: {
            self.daysLabel.textColor = UIColor.white;
        }, completion: completion)
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
        if self.data.lastSuccessUpdate == nil {
            return;
        }
        let diff = self.dayInterval - self.getRemainingTime();
        
        if diff > 0 {
            self.enableButtonAfterInterval(timeInterval: TimeInterval(diff));
        }
    }
    
    func initNotifications() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            self.setupNotificaitons();
        }
    }
    
    func setupNotificaitons() -> Void {
        let center = UNUserNotificationCenter.current();

        let content = UNMutableNotificationContent()
        content.title = "Strick!";
        content.body = "Was this day a successful day?";
        content.badge = 1;
        content.sound = UNNotificationSound.default();
        
        var dateComponent = DateComponents();
        dateComponent.hour = 21;
        dateComponent.minute = 0;
        
        let trigger  = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true);
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger);
        
        center.removeAllPendingNotificationRequests();
        center.add(request) { (error) in
            
        }
    }
}

