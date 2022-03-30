//
//  Date+Extension.swift
//  StrayAnimalsMap
//
//  Created by 陳列 on 2022/3/15.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        let result = formatter.string(from: self)
        return result
    }
    
    func toStringDetail() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        let result = formatter.string(from: self)
        return result
    }
    
    func toStringJustTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        let result = formatter.string(from: self)
        return result
    }
}
