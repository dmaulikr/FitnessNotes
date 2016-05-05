//
//  HistoryViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/4/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CVCalendar
import CocoaLumberjack

class HistoryViewController: UIViewController {

    @IBOutlet var calendarMenuView: CVCalendarMenuView!
    @IBOutlet var calendarView: CVCalendarView!
    
    @IBOutlet var calendarViewSegment: UISegmentedControl!
    
    @IBOutlet var tableView: UITableView!
    
    var selectedDay: DayView!
    
    var dataFormatter: NSDateFormatter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataFormatter = NSDateFormatter()
        dataFormatter?.dateFormat = "MMM yyyy"
        self.navigationItem.title = dataFormatter?.stringFromDate(CVDate(date: NSDate()).convertedDate()!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
    }
    
    //MARK: - IBActions
    
    @IBAction func CalendarViewSegmentTapped(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            calendarView.changeMode(.WeekView)
        case 1:
            calendarView.changeMode(.MonthView)
        default:
            DDLogWarn("impossible, some other value of week and month change happened!!!")
        }
    }
    
    @IBAction func TodayButtonTapped(sender: UIBarButtonItem) {
         calendarView.toggleCurrentDayView()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoryViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    // TODO: func to query database to read the workout history of that day
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
    }
    
    //when month change, update the CVDate
    func presentedDateUpdated(date: CVDate) {
        let currentMonthYear = date.convertedDate()
        self.navigationItem.title = dataFormatter?.stringFromDate(currentMonthYear!)
    }
    
    // TODO: update the dot marker based on the workout history
    ///- returns: true -- there is dot mark at dayView
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let randomDay = Int(arc4random_uniform(31))
        if day == randomDay {
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
}

extension HistoryViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}



















