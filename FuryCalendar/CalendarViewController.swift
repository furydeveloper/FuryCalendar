//
//  CalendarViewController.swift
//  FuryCalendar
//
//  Created by onvit on 2021/07/08.
//

import UIKit
import Then
import SnapKit

class CalendarViewController: UIViewController {
  
  private lazy var calendarView = CalendarView(showScheduleList: true).then {
    $0.todayTextColor = .white
    $0.todayBackgroundColor = .orange
    $0.isBlurredLastWeek = true
    $0.checkBackgroudColor = #colorLiteral(red: 0.8991323113, green: 0.7407200933, blue: 0.4620664716, alpha: 1)
    $0.delegate = self
  }
  
  override func loadView() {
    super.loadView()
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    let guide = view.safeAreaLayoutGuide
    
    [calendarView]
      .forEach { view.addSubview($0) }
    
    calendarView.snp.makeConstraints {
      $0.edges.equalTo(guide)
    }
  }
}

extension CalendarViewController: CalendarViewDelegate {
  
}
