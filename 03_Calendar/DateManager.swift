//
//  DateManager.swift
//  03_Calendar
//
//  Created by Hitomi Mikuni on 2017/04/06.
//  Copyright © 2017年 Hitomi Mikuni. All rights reserved.
//

import UIKit

extension Date {
    
    func monthAgoDate() -> Date {
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return calendar.date(byAdding: dateComponents, to: self)!
    }
    
    func monthLaterDate() -> Date {
        let addValue: Int = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        
        return calendar.date(byAdding: dateComponents, to: self)!
    }
}

class DateManager: NSObject {
    
    var currentMonthOfDates = [NSDate]() //表記する月の配列
    var selectedDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int! = 0 //セルの個数
    
    // 月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth() as Date)
        let numberOfWeeks = Int((rangeOfWeeks?.count)!) //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    // 月の初日を取得
    func firstDateOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from:selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        
        return firstDateMonth
    }
    
    // ⑴表記する日にちの取得
    func dateForCellAtIndexPath(numberOfItem: Int) {
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        for i in 0 ..< numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = Calendar.current.date(byAdding: dateComponents as DateComponents, to: firstDateOfMonth() as Date)!
            // ④配列に追加
            currentMonthOfDates.append(date as NSDate)
        }
    }
    
    // ⑵表記の変更
    func conversionDateFormat(indexPath: IndexPath, headerMonth: String) -> String {
        dateForCellAtIndexPath(numberOfItem: numberOfItems)
        
        let formatter: DateFormatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM"
        
        // 表示対象の年月でない場合は空白を返却
        let month = formatter.string(from: currentMonthOfDates[indexPath.row] as Date)
        if month != headerMonth {
            return ""
        }
        
        formatter.dateFormat = "d"
        
        return formatter.string(from: currentMonthOfDates[indexPath.row] as Date)
    }
    
    // 前月の表示
    func prevMonth(date: Date) -> Date {
        
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        
        return selectedDate
    }
    
    // 次月の表示
    func nextMonth(date: Date) -> Date {
        
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        
        return selectedDate
    }
}
