//
//  PillsModel.swift
//  Pill Box
//
//  Created by Дмитрий Подольский on 08.12.2020.
//

import Foundation
import UIKit
//struct Pills {
//    var imgEmoji: String
//    var name: String
//    var description: String
//    var isPush: Bool
//}

class Pills{
    let defaults = UserDefaults.standard
    
    static let shared = Pills()
    struct PillsBox:Codable {
        var imgEmoji: String
        var name:String
        var description:String
        var isPush: Bool
        var countOfDays:String?
        var regularityOfMonth:String?
        var countPillsOfDay:String?
        var countPillsOfBox:String
        var countPillsOfOneUse:String
        var dateField:String
    }

    var box:[PillsBox]{

        get{
            if let data = defaults.value(forKey: "box") as? Data{
                return try! PropertyListDecoder().decode([PillsBox].self, from: data)
            } else {
                return [PillsBox]()
            }
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue){
                defaults.set(data, forKey: "box")
            }
        }
    }
    func saveBox(imgEmoji:String, name: String, description: String, isPush:Bool,
    countOfDays: String, regularityOfMonth:String, countPillsOfDay:String, countPillsOfBox:String,
    countPillsOfOneUse:String
    , dateField:String
    ) {
        let boxPills = PillsBox(imgEmoji: imgEmoji, name: name, description: description, isPush: isPush,countOfDays: countOfDays, regularityOfMonth: regularityOfMonth, countPillsOfDay: countPillsOfDay, countPillsOfBox: countPillsOfBox,countPillsOfOneUse: countPillsOfOneUse
                                , dateField:dateField
        )
        box.insert(boxPills, at: 0)
    }
}
