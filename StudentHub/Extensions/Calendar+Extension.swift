//
//  Calendar+Extension.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/30/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation

extension Calendar {
    func getCurrentTimeHoursMins(date: Date) -> String {
        enum Meridiem: String {
            case pm = "PM"
            case am = "AM"
        }
        
        var hour = self.component(.hour, from: date)
        let minute = self.component(.minute, from: date)
        var time = "\(hour):\(minute)"
        var meridiemTime: Meridiem = .am
        
        switch hour {
        case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9:
            meridiemTime = .am
            break
        case 10:
            hour = 10
            meridiemTime = .am
            break
        case 11:
            hour = 11
            meridiemTime = .am
            break
        case 12:
            hour = 12
            meridiemTime = .pm
            break
        case 13:
            hour = 1
            meridiemTime = .pm
            break
        case 14:
            hour = 2
            meridiemTime = .pm
            break
        case 15:
            hour = 3
            meridiemTime = .pm
            break
        case 16:
            hour = 4
            meridiemTime = .pm
            break
        case 17:
            hour = 5
            meridiemTime = .pm
            break
        case 18:
            hour = 6
            meridiemTime = .pm
            break
        case 19:
            hour = 7
            meridiemTime = .pm
            break
        case 20:
            hour = 8
            meridiemTime = .pm
            break
        case 21:
            hour = 9
            meridiemTime = .pm
            break
        case 22:
            hour = 10
            meridiemTime = .pm
            break
        case 23:
            hour = 11
            meridiemTime = .pm
            break
        case 24:
            hour = 0
            meridiemTime = .am
            break
        default:
            print("Wrong time")
        }
        
        
        if (Int(hour) < 10) {
            
            time = "0\(hour)"
        }
        else {
            time = "\(hour)"
        }
        if (minute < 10) {
            time += ":0\(minute)"
        }
        else {
            time += ":\(minute)"
        }
        return "\(time) \(meridiemTime)"
    }
}
