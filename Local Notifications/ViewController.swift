//
//  ViewController.swift
//  Local Notifications
//
//  Created by R on 15/05/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    //Outlet
    @IBOutlet weak var listNotfication: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var timerstatus: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timerNotification: UILabel!
   
    //Variables
    let timerPicker = [5,10,20,30,]
    var timer1 = 5
    var sum = 0
    var notifications = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        clear()
    }
    
    //MARK: - StartTimerButton
    @IBAction func startTimer(_ sender: UIButton) {
        start()
    }
    //MARK: - NewDayButton
    @IBAction func newday(_ sender: Any) {
          alert(titll: "new day", message: "yoy will start new day") {
          self.clear()
        }
    }
    //MARK: - CancelButton
    @IBAction func cancel(_ sender: Any) {
        alert(titll: "cancel", message: "yoy will cancel notification") {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            self.timerstatus.text = "\(self.timer1)cancelled"
            self.notifications.removeLast()
            self.notifications.append(self.timerstatus.text!)


        }

        
    }
    //MARK: - NotificationList
    @IBAction func notificationList(_ sender: UIBarButtonItem) {
        
        pickerView.isHidden = !pickerView.isHidden
        addButton.isHidden = !addButton.isHidden
        timerstatus.isHidden = !timerstatus.isHidden
        timerNotification.isHidden = !timerNotification.isHidden
        listNotfication.isHidden = !listNotfication.isHidden
        var allnotification =  ""
        for i in notifications{
            allnotification += i + ","
        }
        listNotfication.text = allnotification
    }
    func start(){
       print(timer1)
        let myminut = timer1 * 60
        notification(minut:myminut)
    }
    
    func clear(){
        timerNotification.text = ""
        sum = 0
        total.text = "total time: \(sum)"
        let hour = sum / 60
        timer.text = "\(hour)hour,\(sum % 60)min"
        
        timerstatus.text = ""
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

    }
    
    //MARK: - Notification
    func notification(minut:Int){
                    //1::notification Permission
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
                    }
                   
                    //2::notification Content
                        let content = UNMutableNotificationContent()
                      content.title = NSString.localizedUserNotificationString(forKey: "Good jop!", arguments: nil)
                      content.body = NSString.localizedUserNotificationString(forKey: "Time is End!", arguments: nil)
                      content.sound = UNNotificationSound.default
                    
                    
                    //3:: notification Trigger
                        let date = Date().addingTimeInterval(TimeInterval(minut))
                        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
                        print(dateComponent)
        timerNotification.text = "work until \(dateComponent.hour!):\(dateComponent.minute!)"
        sum += timer1
        total.text = "total time: \(sum)"
        let hour = sum / 60
        timer.text = "\(hour)hour,\(sum % 60)min"
        timerstatus.text = "\(timer1) min timer set"
        notifications.append(timerstatus.text!)
        
        
        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)

                    //4:: notification Request
                    let uuid = UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
                    
                    //5: notification Register
                    center.add(request) { (error) in
                        
                    }
        }
    //MARK: - Notification
    func alert(titll:String,message:String,action1: @escaping () -> ()){
        let alert = UIAlertController(title: titll, message: message, preferredStyle: UIAlertController.Style.alert)
                
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            action1()
           }))

                
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    alert .dismiss(animated: true, completion: nil)
           }))

            self.present(alert, animated: true, completion: nil)
    }
            
            
        
        
    }
//MARK: - extension
extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timerPicker.count // number of dropdown items
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(timerPicker[row])" + " minutes"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timer1 = timerPicker[row] //  dropdown items
    }
    
    
}
    



