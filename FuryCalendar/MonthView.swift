//
//  MonthView.swift
//  FuryCalendar
//
//  Created by onvit on 2021/07/08.
//

import UIKit

protocol MonthViewDelegate: AnyObject {
  func didChangeMonth(month: Int, year: Int)
}

class MonthView: UIView {
  
  weak var delegate: MonthViewDelegate?
  private var month: Int
  private var year: Int
  
  private lazy var titleLabel = UILabel().then {
    $0.text = "\(year)년 \(month)월"
    $0.textColor = .black
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 25, weight: .bold)
  }
  private let leftButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
    $0.contentMode = .scaleAspectFit
    $0.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
  }
  private let rightButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    $0.tintColor = .black
    $0.contentMode = .scaleAspectFit
    $0.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
  }
  
  override init(frame: CGRect) {
    month = Calendar.current.component(.month, from: Date())
    year = Calendar.current.component(.year, from: Date())
    super.init(frame: frame)
    attribute()
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    month = Calendar.current.component(.month, from: Date())
    year = Calendar.current.component(.year, from: Date())
    super.init(coder: coder)
    attribute()
    setupUI()
  }
  
  private func attribute() {
    backgroundColor = .clear
  }
  
  private func setupUI() {
    let margins: CGFloat = 20
    
    [titleLabel, leftButton, rightButton]
      .forEach { addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.center.equalTo(self)
    }
    
    leftButton.snp.makeConstraints {
      $0.top.bottom.equalTo(self)
      $0.leading.equalTo(self).offset(margins)
    }
    
    rightButton.snp.makeConstraints {
      $0.top.bottom.equalTo(self)
      $0.trailing.equalTo(self).offset(-margins)
    }
  }
}

// MARK:- Selector

private extension MonthView {
  @objc func btnLeftRightAction(sender: UIButton) {
    if sender == rightButton {
      month += 1
      if month > 12 {
        month = 1
        year += 1
      }
    } else {
      month -= 1
      if month < 1 {
        month = 12
        year -= 1
      }
    }
    
    delegate?.didChangeMonth(month: month, year: year)
    titleLabel.text = "\(year)년 \(month)월"
  }
}
