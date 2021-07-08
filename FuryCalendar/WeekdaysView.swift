//
//  WeekdaysView.swift
//  FuryCalendar
//
//  Created by onvit on 2021/07/08.
//

import UIKit

class WeekdaysView: UIView {
  private var stackView = UIStackView().then {
    $0.distribution = .fillEqually
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    attribute()
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    attribute()
    setupUI()
  }
  
  private func attribute() {
    backgroundColor = .white
    
    for day in ["일", "월", "화", "수", "목", "금", "토"] {
      let label = UILabel()
      label.text = day
      label.textAlignment = .center
      label.font = .systemFont(ofSize: 15, weight: .medium)
      label.textColor = day == "일" ? #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) : day == "토" ? #colorLiteral(red: 0.05779109589, green: 0.1568627506, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      stackView.addArrangedSubview(label)
    }
  }
  
  private func setupUI() {
    [stackView]
      .forEach { addSubview($0) }
    
    stackView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
  }
}
