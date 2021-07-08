//
//  ScheduleCell.swift
//  FuryCalendar
//
//  Created by onvit on 2021/07/08.
//

import UIKit

class ScheduleCell: UITableViewCell {
  
  static let identifier = "ScheduleCell"
  
  private lazy var containerView = UIView().then {
    $0.layer.cornerRadius = 4
    $0.backgroundColor = .white
    $0.layer.masksToBounds = false
    $0.layer.shadowOpacity = 1.0
    $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    $0.layer.shadowColor = #colorLiteral(red: 0.8378050499, green: 0.8378050499, blue: 0.8378050499, alpha: 1)
    $0.layoutIfNeeded()
  }
  
  private let dayLabel = UILabel().then {
    $0.text = "3일"
    $0.textColor = .white
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 21, weight: .bold)
    $0.backgroundColor = .orange
    $0.layer.cornerRadius = 4
    $0.layer.masksToBounds = true
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    $0.layoutIfNeeded()
  }
  private lazy var contentsStackView = UIStackView().then {
    $0.addArrangedSubview(titleLabel)
    $0.addArrangedSubview(timeLabel)
    $0.axis = .vertical
    $0.spacing = 2
  }
  private let titleLabel = UILabel().then {
    $0.text = "병원 방문 및 설치"
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 19, weight: .medium)
  }
  private let timeLabel = UILabel().then {
    $0.text = "15:00-16:00"
    $0.textColor = .lightGray
    $0.font = .systemFont(ofSize: 15, weight: .medium)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
  }
  
  private func setupUI() {
    backgroundColor = .white
    
    let margins: CGFloat = 15
    
    [containerView]
      .forEach { contentView.addSubview($0) }
    
    [dayLabel, contentsStackView]
      .forEach { containerView.addSubview($0) }
    
    containerView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
    }
    
    dayLabel.snp.makeConstraints {
      $0.top.leading.bottom.equalTo(containerView)
      $0.width.height.equalTo(60)
    }
    
    contentsStackView.snp.makeConstraints {
      $0.centerY.equalTo(contentView)
      $0.leading.equalTo(dayLabel.snp.trailing).offset(margins)
      $0.trailing.equalTo(containerView)
    }
  }
}
