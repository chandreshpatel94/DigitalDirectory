//
//  BaseViewController.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 22/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func tappedBackButton(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
}
