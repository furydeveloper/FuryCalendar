//
//  CalendarView.swift
//  FuryCalendar
//
//  Created by onvit on 2021/07/08.
//

import UIKit

@objc protocol CalendarViewDelegate: AnyObject {
  @objc optional func didSelectDay(_ date: Date)
  @objc optional func didSelectDay(_ year: Int, month: Int, day: Int)
}

class CalendarView: UIView {
  weak var delegate: CalendarViewDelegate?
  
  /// initializer
  /// 달력 아래 일정 표시
  private var showScheduleList: Bool
  
  /// 지난날 흐리게 처리
  var isBlurredLastWeek: Bool = false
  
  /// 오늘 TextColor
  var todayTextColor: UIColor? = .black
  
  /// 오늘 BackgroudColor
  var todayBackgroundColor: UIColor? = .white
  
  /// 일정이 있을 때 BackgroudColor
  var checkBackgroudColor: UIColor? = .white
  
  /// 현재 선택된 년도
  private var year: Int
  /// 현재 선택된 달
  private var month: Int
  /// 달별 일 수
  private var numOfDaysInMonth = [31, 28, 31, 30, 31,
                                  30, 31, 31, 30, 31,
                                  30, 31]
  /// 첫 주의 시작 요일
  /// (Sunday - Saturday 1 - 7)
  private var firstWeekDayOfMonth: Int {
    return ("\(year)-\(month)-01".date?.firstDayOfTheMonth.weekday)!
  }
  /// 몇주차까지 있는가?
  private var weekOfMonth: Int {
    let dateComponents = DateComponents(year: year, month: month)
    let monthCurrentDayFirst = Calendar.current.date(from: dateComponents)!
    let monthNextDayFirst = Calendar.current.date(byAdding: .month, value: 1, to: monthCurrentDayFirst)!
    let monthCurrentDayLast = Calendar.current.date(byAdding: .day, value: -1, to: monthNextDayFirst)!
    return Calendar.current.component(.weekOfMonth, from: monthCurrentDayLast)
  }
  
  private lazy var monthView = MonthView().then {
    $0.delegate = self
  }
  private let weekDaysView = WeekdaysView()
  private lazy var calendarCollectinView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
    return collectionView
  }()
  private lazy var calendarTableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
    $0.dataSource = self
    $0.delegate = self
    $0.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
  }
  
  init(frame: CGRect = .zero, showScheduleList: Bool = false) {
    self.showScheduleList = showScheduleList
    year = Calendar.current.component(.year, from: Date())
    month = Calendar.current.component(.month, from: Date())
    
    super.init(frame: frame)
    calculateLeapYear()
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func makeFullDate(year: Int, month: Int, day: Int) -> String {
    let strMonth = month < 10 ? "0\(month)" : "\(month)"
    let strDay = day < 10 ? "0\(day)" : "\(day)"
    
    return "\(year)-\(strMonth)-\(strDay)"
  }
  
  private func calculateLeapYear() {
    if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
      numOfDaysInMonth[1] = 29
    }
  }
  
  private func setupUI() {
    let margins: CGFloat = 15
    
    [monthView, weekDaysView, calendarCollectinView]
      .forEach { addSubview($0) }
    
    monthView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self)
      $0.height.equalTo(70)
    }
    
    weekDaysView.snp.makeConstraints {
      $0.top.equalTo(monthView.snp.bottom)
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(40)
    }
    
    calendarCollectinView.snp.makeConstraints {
      $0.top.equalTo(weekDaysView.snp.bottom)
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(weekOfMonth * 60)
    }
    
    if showScheduleList == true {
      addSubview(calendarTableView)
      calendarTableView.snp.makeConstraints {
        $0.top.equalTo(calendarCollectinView.snp.bottom).offset(margins)
        $0.leading.trailing.bottom.equalTo(self)
      }
    }
  }
  
//  private func setupUIWithScheduleList() {
//    let margins: CGFloat = 15
//
//    [monthView, weekDaysView, calendarCollectinView, calendarTableView]
//      .forEach { addSubview($0) }
//
//    monthView.snp.makeConstraints {
//      $0.top.leading.trailing.equalTo(self)
//      $0.height.equalTo(70)
//    }
//
//    weekDaysView.snp.makeConstraints {
//      $0.top.equalTo(monthView.snp.bottom)
//      $0.leading.trailing.equalTo(self)
//      $0.height.equalTo(40)
//    }
//
//    calendarCollectinView.snp.makeConstraints {
//      $0.top.equalTo(weekDaysView.snp.bottom)
//      $0.leading.trailing.equalTo(self)
//      $0.height.equalTo(weekOfMonth * 60)
//    }
//
//    calendarTableView.snp.makeConstraints {
//      $0.top.lessThanOrEqualTo(calendarCollectinView.snp.bottom).offset(margins)
//      $0.leading.trailing.bottom.equalTo(self)
//    }
//  }
}

extension CalendarView: MonthViewDelegate {
  func didChangeMonth(month: Int, year: Int) {
    self.month = month
    self.year = year
    calendarCollectinView.snp.updateConstraints {
      $0.height.equalTo(weekOfMonth * 60)
    }
    calculateLeapYear()
    calendarCollectinView.reloadData()
  }
}

extension CalendarView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numOfDaysInMonth[month - 1] + firstWeekDayOfMonth - 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
    cell.isUserInteractionEnabled = false
    cell.daylabel.backgroundColor = .clear
    
    if indexPath.item <= firstWeekDayOfMonth - 2 {
      /// 지난달
    } else if indexPath.item >= numOfDaysInMonth[month - 1] + firstWeekDayOfMonth - 1 {
      /// 다음달
    } else {
      /// 선택한달
      cell.isUserInteractionEnabled = true
      let calculatedDay = indexPath.row - firstWeekDayOfMonth + 2
      
      cell.setDate(year: year,
                   month: month,
                   day: calculatedDay)
      
      if (indexPath.row + 1) % 7 == 0 {
        cell.setDay(isSaturday: true)
      } else if indexPath.row % 7 == 0 {
        cell.setDay(isSunday: true)
      } else {
        cell.setDay()
      }
      
      /// 지난날
      let date = "\(year)-\(month)-\(calculatedDay)".date!
      if date.timeIntervalSinceNow.sign == .minus && isBlurredLastWeek == true {
        cell.setBlurred()
      } else {
        cell.removeBlurred()
      }
      
      /// 오늘 표시
      if calculatedDay == Calendar.current.component(.day, from: Date()) && month == Calendar.current.component(.month, from: Date()) {
        cell.setToday(todayTextColor, backgroundColor: todayBackgroundColor)
      }
    }
    
    return cell
  }
}

extension CalendarView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! DateCell
    delegate?.didSelectDay?(cell.year, month: cell.month, day: cell.day)
    delegate?.didSelectDay?(cell.date)
  }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width / 7
    return CGSize(width: width, height: 60)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}

extension CalendarView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath) as! ScheduleCell
    cell.selectionStyle = .none
    return cell
  }
}

extension CalendarView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

extension String {
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
  
  var date: Date? {
    return String.dateFormatter.date(from: self)
  }
}

extension Date {
  var weekday: Int {
    return Calendar.current.component(.weekday, from: self)
  }
  
  var firstDayOfTheMonth: Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
  }
  
  func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
    return calendar.dateComponents(Set(components), from: self)
  }
  
  func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
    return calendar.component(component, from: self)
  }
}
