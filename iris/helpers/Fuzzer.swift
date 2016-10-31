//
//  Fuzzer.swift
//  iris
//
//  Created by Kyle Milner on 27/10/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

final class Fuzzer {

    private struct Time {
        static let days = "days"
        static let day = "day"
        static let today = "today"

        static let hours = "hours"
        static let hour = "hour"

        static let minutes = "mins"
        static let minute = "minute"
    }

    private struct Approximations {
        static let about = "about"
        static let few = "a few"
        static let couple = "a couple"

        static let half = "half"
        static let quarter = "quarter"

        static let many = "many"
    }


    static func fuzz(until: Date) -> String {

        let remaining = Calendar.current.dateComponents([.day, .hour, .minute],
                                                        from: Date(),
                                                        to: until)
        if let days = remaining.day, days > 0 {
            return "\(days) \(Time.days)"
        }

        if let hours = remaining.hour, hours > 0, hours < 24 {
            return fuzzy(hours: hours)

        }

        if let mins = remaining.minute, mins < 60 {
            return fuzzy(minutes: mins)
        }

        return "Unknown"
    }

    static func fuzzy(hours: Int) -> String {

        switch hours {
        case 24...Int.max:
            return "\(Approximations.many) \(Time.hours)"
        case 18..<24:
            return about(value: "a", units: Time.day)
        case 12..<18:
            return Time.today
        case 4..<12:
            return "\(Approximations.few) \(Time.hours)"
        case 1..<4:
            return "\(Approximations.couple) \(Time.hours)"
        case 1:
            return about(value: "an", units: Time.hour)
        default:
            return "less than an \(Time.hour)"
        }
    }

    static func fuzzy(minutes: Int) -> String {
        switch minutes {
        case 60...Int.max:
            return "more than an \(Time.hour)"
        case 45..<60:
            return about(value: "an", units: Time.hour)
        case 25..<45:
            return about(value: "\(Approximations.half) an", units: Time.hour)
        case 10..<25:
            return about(value: "20", units: Time.minutes)
        case 5..<10:
            return about(value: "10", units: Time.minutes)
        case 0..<5:
            return "\(Approximations.few) \(Time.minutes)"
        default:
            return "less than a \(Time.minutes)"
        }

    }


    static func about(value: String, units: String) -> String {
        return "\(Approximations.about) \(value) \(units)"
    }
}
