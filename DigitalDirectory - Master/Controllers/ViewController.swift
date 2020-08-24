//
//  ViewController.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 22/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
  
}

class ViewController: BaseViewController {
  
  @IBOutlet weak var categoryButton: UIButton!
  @IBOutlet weak var proceedButton: UIButton!
  
  let transparentView = UIView()
  let tableView = UITableView()
  private let categoryList = ["Bank", "Restaurant"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  private func setupUI() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    proceedButton.roundView()
  }
  
  private func addTransparentView() {
    transparentView.frame = view.frame
    view.addSubview(transparentView)
    
    let frames = categoryButton.frame
    tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: 0)
    tableView.layer.cornerRadius = 5
    view.addSubview(tableView)
    tableView.reloadData()
    transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    transparentView.addGestureRecognizer(tapGesture)
    transparentView.alpha = 0.0
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
      self.transparentView.alpha = 0.5
      self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: CGFloat(self.categoryList.count * 50))
    }, completion: nil)
  }
  
  @objc func removeTransparentView() {
    let frames = categoryButton.frame
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
      self.transparentView.alpha = 0.0
      self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    }, completion: nil)
  }
  
  @IBAction func tappedSelectCategoryButton(_ sender: Any) {
    addTransparentView()
  }
  
  @IBAction func tappedProceedButton(_ sender: Any) {
    let buttonTitle = categoryButton.titleLabel?.text
    if buttonTitle != "Select Category" {
      let controller = AppFunction.shared.viewControllerWith(ListViewController.storyboardIdentifier) as! ListViewController
      controller.setTitle = buttonTitle ?? "Bank"
      navigationController?.pushViewController(controller, animated: true)
    } else {
      showAlert(message: "Please select category", title: "Error!")
    }
  }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = categoryList[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    removeTransparentView()
    categoryButton.setTitle(categoryList[indexPath.row], for: .normal)
  }
}
