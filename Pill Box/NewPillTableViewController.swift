//
//  NewPillTableViewController.swift
//  Pill Box
//
//  Created by Дмитрий Подольский on 08.12.2020.
//

import UIKit
import UserNotifications

struct KeysDefaults {
    static let keyImgEmoji = "imgEmoji"
    static let keyName = "name"
    static let keyDescription = "description"
    static let keyIsPush = "isPush"
    static let keyCountPillsOfOneUse = "countPillsOfOneUse"
}

class NewPillTableViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var notifications = Notifications()
    var emoji = Pills.PillsBox(imgEmoji: "💊", name: "", description: "", isPush: false,
                               countOfDays: "", regularityOfMonth:"", countPillsOfDay:"", countPillsOfBox:"",countPillsOfOneUse: ""
                               , dateField:""
    )
    
//    var timePush: String = ""
    
    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var namePillTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var dateStartTextField: UIDatePicker!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var countOfDayTextFiled: UITextField!
    @IBOutlet weak var regularityOfMonthTextField: UITextField!
    @IBOutlet weak var countPillsOfDayTextField: UITextField!
    @IBOutlet weak var countPillsOfBoxTextField: UITextField!
    @IBOutlet weak var countPillsOfOneUseTextField: UITextField!
    

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var switchText: UILabel!
    
   let datePicker = UIDatePicker()
    var dayByNewPills = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.inputView = datePicker
        datePicker.datePickerMode = .time
        datePickerUpdaate()
        updateUI()
        saveButtonState()
//        minusPillIsBox()
//        howDays()
        print(dayByNewPills)
    }

    func datePickerUpdaate() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
      
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace], animated: true)
        
        dateField.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
       
    }
    
    @objc  func dateChanged() {
        getDateFromPicker()
        view.endEditing(true)
        notificationSwitch.isOn = false
    }
    
    func getDateFromPicker(){
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        dateField.text = formatter.string(from: datePicker.date)
    }
    
    private func saveButtonState() {
        let emojiText = emojiTextField.text ?? ""
        let nameText = namePillTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let countPillsOfOneUseText = countPillsOfOneUseTextField.text ?? ""
        let countOfDaysText = countOfDayTextFiled.text ?? ""
        let regularityOfMonthText = regularityOfMonthTextField.text ?? ""
        let countPillsOfDayText = countPillsOfDayTextField.text ?? ""
        let countPillsOfBoxText = countPillsOfBoxTextField.text ?? ""
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty && !countPillsOfOneUseText.isEmpty && !countOfDaysText.isEmpty && !regularityOfMonthText.isEmpty && !countPillsOfDayText.isEmpty && !countPillsOfBoxText.isEmpty
         
    }
    
     func updateUI() {
   
        emojiTextField.text = emoji.imgEmoji
        namePillTextField.text = emoji.name
        descriptionTextField.text = emoji.description
        countOfDayTextFiled.text = emoji.countOfDays
        regularityOfMonthTextField.text = emoji.regularityOfMonth
        countPillsOfDayTextField.text = emoji.countPillsOfDay
        countPillsOfBoxTextField.text = emoji.countPillsOfBox
 
      
        countPillsOfOneUseTextField.text = emoji.countPillsOfOneUse
        notificationSwitch.isOn = emoji.isPush
        dateField.text = emoji.dateField
        switchText.text = setLabelStatus(onOff: notificationSwitch.isOn)
    }
    
    @IBAction func textFieldChangeAction(_ sender: UITextField) {
        saveButtonState()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else {return}
        
        let emoji = emojiTextField.text ?? ""
        let name = namePillTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let countPillsOfOneUse = countPillsOfOneUseTextField.text ?? ""
        let countOfDays = countOfDayTextFiled.text ?? ""
        let regularityOfMonth = regularityOfMonthTextField.text ?? ""
        let countPillsOfDay = countPillsOfDayTextField.text ?? ""
        let countPillsOfBox = countPillsOfBoxTextField.text ?? ""
        let dateFieldV = dateField.text ?? "00:00"
        
        self.emoji = Pills.PillsBox(imgEmoji: emoji, name: name, description: description, isPush: self.emoji.isPush, countOfDays: countOfDays, regularityOfMonth:regularityOfMonth, countPillsOfDay:countPillsOfDay, countPillsOfBox: countPillsOfBox, countPillsOfOneUse: countPillsOfOneUse
                                    , dateField: dateFieldV
        )
    }
 
    
    
    @IBAction func onOffNotification(_ sender: Any) {
        emoji.isPush = setDes(onOff: notificationSwitch.isOn)
        switchText.text = setLabelStatus(onOff: notificationSwitch.isOn)
        
        if emoji.isPush == true {
            onOffNotificationAction()
            onOffNotificationActionByNewPills()
        }
       
    }
   
    func setDes(onOff: Bool) -> Bool {
        if onOff {
            return true
        }
        if !onOff {
            return false
        }
return false
    }
    
    func setLabelStatus(onOff: Bool) -> String {
        if onOff {
            return "Включено"
        }
        if !onOff {
            return "Выключено"
        }
return "?"
    }


    func onOffNotificationAction() {
        let notificationType = emoji
        let time:String = dateField.text!
        self.notifications.scheduleNotification(notificationType: notificationType.name, notificationBody: notificationType.imgEmoji, time: time)
       
    }
    
    func onOffNotificationActionByNewPills() {
        let notificationType = emoji
        let time:String = dateField.text!
        self.notifications.scheduleNotificationByNewPills(notificationType: "Таблетки " + notificationType.name + " cкоро закончатся", notificationBody: notificationType.imgEmoji, time: time)
       
    }
    
    
    func minusPillIsBox()  {
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "HH:mm:ss"
        let dateGlobal = formatter.string(from: date)
        if dateGlobal == "15:35:01"  {
            let fisrt = Int(countPillsOfBoxTextField.text!)
            let second = fisrt! - Int(countPillsOfOneUseTextField.text!)!
            countPillsOfBoxTextField.text = String(second)
     
        }
}
//    func howDays() {
//        let countPillsOfBoxTextFieldInt =  Int(countPillsOfBoxTextField.text!) ?? 0
//        let countPillsOfOneUseTextFieldInt = Int(countPillsOfOneUseTextField.text!) ?? 0
//    let countOfDayTextFiledInt = Int(countPillsOfDayTextField.text!) ?? 0
//
//        let countDaysByNewPills = countPillsOfBoxTextFieldInt / (countPillsOfOneUseTextFieldInt * countOfDayTextFiledInt)
//
//        dayByNewPills = String(countDaysByNewPills)
//    }
    
  

    
}
