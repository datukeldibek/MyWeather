//
//  Extension + Date.swift
//  MyWeather
//
//  Created by Jarae on 14/9/23.
//

import Foundation

extension Date{

    var stringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("EE dd MMM")
        return dateFormatter.string(from: self)
    }
    
    var hourValue: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: self)) ?? 12
    }
    
    var timeValue: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
