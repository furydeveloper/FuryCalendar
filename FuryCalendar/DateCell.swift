//
//  DateCell.swift
//  FuryCalendar
//
//  Created by onvit on 2021/07/08.
//

import UIKit

class DateCell: UICollectionViewCell {
  static let identifier = "DateCell"
  
  var year: Int = 0
  var month: Int = 0
  var day: Int = 0 { didSet { daylabel.text = "\(day)" } }
  var date: Date {
    let dateComponents = DateComponents(year: year, month: month, day: day)
    return Calendar.current.date(from: dateComponents)!
  }
  
  private let checkView = UIView().then {
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  lazy var daylabel = UILabel().then {
    $0.textColor = .black
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 19, weight: .regular)
    $0.layer.cornerRadius = contentView.frame.width / 2.8
    $0.clipsToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    daylabel.text = nil
    daylabel.alpha = 1.0
    daylabel.textColor = .black
    daylabel.backgroundColor = .clear
    daylabel.font = .systemFont(ofSize: 19, weight: .regular)
    checkView.backgroundColor = .clear
  }
  
  func setToday(_ textColor: UIColor?, backgroundColor: UIColor?) {
    daylabel.textColor = textColor
    checkView.backgroundColor = backgroundColor
  }
  
  func checkBackground(_ color: UIColor?) {
    checkView.backgroundColor = color
  }
  
  /// Day(일) 표시
  func setDay(isSaturday: Bool = false, isSunday: Bool = false) {
    daylabel.textColor = isSaturday ? UIColor.blue : isSunday ? .red : .black
    daylabel.font = .systemFont(ofSize: 19, weight: .regular)
  }
  
  /// 지난달 혹은 다음달 Day(일) 표시
  func setAnotherMonthDay(isSaturday: Bool = false, isSunday: Bool = false) {
    daylabel.textColor = (isSaturday ? UIColor.blue : isSunday ? .red : .black).withAlphaComponent(0.3)
    daylabel.font = .systemFont(ofSize: 15, weight: .regular)
  }
  
  func setDate(year: Int, month: Int, day: Int) {
    self.year = year
    self.month = month
    self.day = day
  }
  
  func setBlurred() {
    daylabel.textColor = daylabel.textColor.withAlphaComponent(0.3)
  }
  
  func removeBlurred() {
    daylabel.textColor = daylabel.textColor.withAlphaComponent(1.0)
  }
  
  func setBackgroundGray() {
    contentView.backgroundColor = #colorLiteral(red: 0.9420694709, green: 0.9422309399, blue: 0.9420593977, alpha: 1)
  }
  
  func setBackgroudWhite() {
    contentView.backgroundColor = .white
  }
  
  private func setupUI() {
    [checkView, daylabel]
      .forEach { contentView.addSubview($0) }
    
    checkView.snp.makeConstraints {
      $0.center.equalTo(contentView)
      $0.width.height.equalTo(contentView.frame.width)
    }
    
    daylabel.snp.makeConstraints {
      $0.center.equalTo(contentView)
      $0.width.height.equalTo(contentView.frame.width / 1.4)
    }
  }
}

