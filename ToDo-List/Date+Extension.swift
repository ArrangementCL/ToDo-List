//
//  Date+Extension.swift
//  StrayAnimalsMap
//
//  Created by 陳列 on 2022/3/15.
//

import Foundation

extension Date {
    
    func calculateTimeDifference(toTheDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        
        let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        let difference = Calendar.current.dateComponents(components, from: self, to: toTheDate)
        
        if difference.day != 0 {
            return formatter.string(from: self)
        } else if difference.hour != 0 {
            return "\(difference.hour!)小時前"
        } else if difference.minute != 0 {
            return "\(difference.minute!)分鐘前"
        } else {
            return "\(difference.second!)秒前"
        }
    }
}
