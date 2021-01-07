//
//  Notifications.swift
//  Notifications
//
//  Created by Дмитрий Подольский on 10.12.2020.
//

import UIKit
import UserNotifications


class Notifications: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()


    var snoozeNewDate:String = ""


    ///Функци запроса отправки пушей при запуске приложение
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else {return}
            ///проверка не отлючено ли разрешение на отправку уведомлений
            self.getNotificationSettings()
        }
    }
    ///Функци проверки не отключил ли пользователь разрешение на отправку уведомлений в настройках
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    ///Метод пуша
    func scheduleNotification(notificationType: String, notificationBody: String, time:  String) {
        let content = UNMutableNotificationContent()
        
        ///идентификатор для определения типа уведомления
        let userAction = "User Action"
       
        content.title = notificationType
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        content.badge = 1
        ///включение категории уведомлений
        content.categoryIdentifier = userAction
        
        
        
        ///тригер для уведомления по точному времени
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let newdate = formatter.date(from: time)

        let triggerDaily = Calendar.current.dateComponents([.hour, .minute], from:newdate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
   
        ///индентификатор для уведомления
        let identifire = notificationType
        ///запрос уведомления
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
    
        ///вызов метода
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
           
        }

        
        ///определение действия в уведомлении (разблокировать устройство, запустить приложение при этов выполнить какое-то действие, деструктивное последствие)
         
        ///отложить уведомление на небольшое количество времени
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Напомнить через 5 мин", options: [])
        
        ///деструктивное решение. Удалить уведомление
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        
        ///инициализация категории
        let category = UNNotificationCategory(identifier: userAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        snoozeNewDate = time
        ///регистрация категорий уведомлений в центре уведомлений
        notificationCenter.setNotificationCategories([category])
    }
    
    func scheduleNotificationByNewPills(notificationType: String, notificationBody: String, time:  String) {
        let content = UNMutableNotificationContent()
        
        ///идентификатор для определения типа уведомления
        let userAction = "User Action"
       
        content.title = notificationType
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        content.badge = 1
        ///включение категории уведомлений
        content.categoryIdentifier = userAction
        
        
        
        ///тригер для уведомления по точному времени
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let newdate = formatter.date(from: time)
        let addminutes = newdate!.addingTimeInterval(1*60)
        
        let triggerDaily2 = Calendar.current.dateComponents([.hour, .minute], from:addminutes)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: triggerDaily2, repeats: true)
   
        ///индентификатор для уведомления
        let identifire = notificationType
        ///запрос уведомления
        let request2 = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger2)
    
        ///вызов метода
        notificationCenter.add(request2) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
           
        }

        
        ///определение действия в уведомлении (разблокировать устройство, запустить приложение при этов выполнить какое-то действие, деструктивное последствие)
         
        ///отложить уведомление на небольшое количество времени
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Напомнить через 5 мин", options: [])
        
        ///деструктивное решение. Удалить уведомление
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        
        ///инициализация категории
        let category2 = UNNotificationCategory(identifier: userAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        snoozeNewDate = time
        ///регистрация категорий уведомлений в центре уведомлений
        notificationCenter.setNotificationCategories([category2])
    }
    
    ///Подключение возможности отправки уведомления в момент работы приложения
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    

    ///реагирование на тап по уведомлению
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "notificationType"  {
        }
        ///настроить приложение от выбора действия при уведомлении
        switch response.actionIdentifier {
        //отклонение уведомления
        case UNNotificationDismissActionIdentifier:
            print("пук")
            print("ну и хули")
        ///если пользователь тапнул по уведомлению
        case UNNotificationDefaultActionIdentifier:
            print("пук")
            print("Default")
        ///если выберет Snooze
        case "Snooze":
            ///логика действия  Snooze (отложить уведомление на небольшое время)
            //Повторить уведомлениче Snooze через 5 мин
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3)) {
                
                self.scheduleNotification(notificationType: response.notification.request.identifier , notificationBody: "", time: self.snoozeNewDate)
            }
        ///удалить уведомление
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
            
        }
         completionHandler()
    }
    
    
  
    
   
}
