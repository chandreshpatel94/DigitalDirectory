//
//  SearchViewController.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 23/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SearchViewController: BaseViewController, UITextFieldDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var searchButton: UIButton!
  
  var bankData = [Bank]()
  var resData = [Restaurant]()
  var filteredBankData = [Bank]()
  var filteredResData = [Restaurant]()
  var setTitle: String = "Bank"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    filteredBankData = bankData
    filteredResData = resData
    searchButton.roundView()
    title = "Search \(setTitle)"
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    tableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
  }
  
  @IBAction func tappedSearchButton(_ sender: Any) {
    if searchTextField.text?.isEmpty ?? false {
      showAlert(message: "Please enter text")
    } else {
      filterData()
    }
  }
  
  private func filterData() {
    if setTitle == "Bank" {
      filteredBankData.removeAll()
      for item in bankData {
        if let text = searchTextField.text?.uppercased(), let name = item.name?.uppercased() {
          if name.contains(text) {
            filteredBankData.append(item)
          }
        }
      }
      tableView.reloadData()
    } else {
      filteredResData.removeAll()
      for item in resData {
        if let text = searchTextField.text?.uppercased(), let name = item.name?.uppercased() {
          if name.contains(text) {
            filteredResData.append(item)
          }
        }
      }
      tableView.reloadData()
    }
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    searchTextField.text = ""
    filteredBankData = bankData
    filteredResData = resData
    tableView.reloadData()
    return false
  }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  setTitle == "Bank" ? filteredBankData.count : filteredResData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
    let headTitle = setTitle == "Bank" ? filteredBankData[indexPath.row].name : filteredResData[indexPath.row].name
    let subtitle = setTitle == "Bank" ? filteredBankData[indexPath.row].branchName : filteredResData[indexPath.row].address
    let city = setTitle == "Bank" ? filteredBankData[indexPath.row].city : filteredResData[indexPath.row].city
    let state = setTitle == "Bank" ? filteredBankData[indexPath.row].state : filteredResData[indexPath.row].state
    cell.configureCell(title: headTitle ?? "", subTitle: subtitle ?? "", city: city ?? "", state: state ?? "")
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
  }
}

//MARK: - UITableViewDelegate, SwipeTableViewCellDelegate
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if setTitle == "Bank" {
      let controller = AppFunction.shared.viewControllerWith(AddBankViewController.storyboardIdentifier) as! AddBankViewController
      controller.bankData = filteredBankData[indexPath.row]
      controller.title = "Edit ".appending(setTitle).appending(" Info")
      navigationController?.pushViewController(controller, animated: true)
    } else {
      let controller = AppFunction.shared.viewControllerWith(AddRestaurantViewController.storyboardIdentifier) as! AddRestaurantViewController
      controller.resData = filteredResData[indexPath.row]
      controller.title = "Edit ".appending(setTitle).appending(" Info")
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}
