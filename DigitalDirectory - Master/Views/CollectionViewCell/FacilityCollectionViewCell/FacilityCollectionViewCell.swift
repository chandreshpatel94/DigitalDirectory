//
//  FacilityCollectionViewCell.swift
//  DigitalDirectory
//
//  Created by CHANDRESH on 22/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit

class FacilityCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var checkImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configureCell(item: String, isCheck: Bool = false) {
    titleLabel.text = item
    checkImageView.image = UIImage(named: isCheck ? "done" : "checkbox")
  }
}
