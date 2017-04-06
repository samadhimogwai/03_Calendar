//
//  ViewController.swift
//  03_Calendar
//
//  Created by Hitomi Mikuni on 2017/04/06.
//  Copyright © 2017年 Hitomi Mikuni. All rights reserved.
//

import UIKit

extension UIColor {
    class func hex ( hexStr : NSString, alpha : CGFloat) -> UIColor {
        var hexStr = hexStr
        let alpha = alpha
        hexStr = hexStr.replacingOccurrences(of: "#", with: "") as NSString
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("error of color setting")
            return UIColor.white
        }
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var headerMonth: String = ""
    
    @IBOutlet weak var PrevBtn: UIButton!
    @IBOutlet weak var NextBtn: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var calenderHeaderView: UIView!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトルを設定
        headerTitle.text = changeHeaderTitle()
        
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.white
        
        // Leftスワイプを定義
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.leftSwipeView(sender:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        // Rightスワイプを定義
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.rightSwipeView(sender:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //　セル数の設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return dateManager.daysAcquisition()
        }
    }
    // 日付を表示する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CalendarCell
        
        // 日付
        let day = dateManager.conversionDateFormat(indexPath: indexPath as IndexPath, headerMonth: headerMonth )
        
        
        // テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.hex(hexStr: "D9305C", alpha: 1)
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.hex(hexStr: "0075C2", alpha: 1)
        } else {
            cell.textLabel.textColor = UIColor.gray
        }
        // テキスト配置
        if indexPath.section == 0 {
            cell.textLabel.text = weekArray[indexPath.row]
        } else {
            cell.textLabel.text = day
        }
        return cell
    }
    
    //　セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = width * 1.0
        return CGSize(width: width, height: height)
        
    }
    
    // セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    // セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    // タイトルを設定
    func changeHeaderTitle() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        headerMonth = formatter.string(from: selectedDate as Date)
        return headerMonth
    }
    
    
    // セルクリック時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        
        // デバッグ用
        if cell == cell {
            print(cell.textLabel.text ?? "nil")
        }
        
    }
    
    
    // 表示月の変更
    func changeMonth(mode: String) {
        
        switch mode {
        case "next":
            selectedDate = dateManager.nextMonth(date: selectedDate as Date) as NSDate
        default:
            selectedDate = dateManager.prevMonth(date: selectedDate as Date) as NSDate
        }
        
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle()
        
    }
    
    // Leftスワイプ時(前月表示)
    func leftSwipeView(sender: UISwipeGestureRecognizer) {
        changeMonth(mode: "prev")
    }
    
    // Rightスワイプ時(次月表示)
    func rightSwipeView(sender: UISwipeGestureRecognizer) {
        changeMonth(mode: "next")
    }
    
    // MARK: Action
    // prevボタン押下時(前月表示)
    @IBAction func tappedPrevBtn(_ sender: UIButton) {
        changeMonth(mode: "prev")
    }
    // nextボタン押下時(次月表示)
    @IBAction func tappedNextBtn(_ sender: UIButton) {
        changeMonth(mode: "next")
    }
    
}

