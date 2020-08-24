//
//  ListTableViewCell.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 22/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit
import SwipeCellKit

class ListTableViewCell: SwipeTableViewCell {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var bankNameLabel: UILabel!
  @IBOutlet weak var branchNameLabel: UILabel!
  @IBOutlet weak var cityTitle: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupView()
  }

  private func setupView() {
    containerView.cornerRadius(radius: 10)
    containerView.addShadow(offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.4)
  }
  
  func configureCell(title: String, subTitle: String, city: String, state: String) {
    bankNameLabel.text = title
    branchNameLabel.text = subTitle
    cityTitle.text = "\(city) - \(state)"
  }
}
