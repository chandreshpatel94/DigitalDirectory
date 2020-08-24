//
//  ListViewController.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 22/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit
import SwipeCellKit
import SVProgressHUD

class ListViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var setTitle: String = "Bank"
  var buttonStyle: ButtonStyle = .circular
  var buttonDisplayMode: ButtonDisplayMode = .imageOnly
  fileprivate var bankViewModel = BankViewModel()
  fileprivate var restaurantViewModel = RestaurantViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if setTitle == "Bank" {
      bankViewModel.fetchBankList()
    } else {
      restaurantViewModel.fetchRestaurantList()
    }
    
    if bankViewModel.isLoading {
      SVProgressHUD.show()
    }
  }
  
  private func setupUI() {
    title = setTitle.appending(" Digital Directory")
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    tableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
  }
  
  private func setupViewModel() {
    bankViewModel.updatedOnBankListFetched = { error in
      if error == nil {
        SVProgressHUD.dismiss()
        if self.bankViewModel.bankListFeed.count > 0 {
          self.tableView.reloadData()
        } else {
          self.tableView.isHidden = true
          self.showAlert(message: "No Data Found")
        }
      } else {
        self.showAlert(message: error?.localizedDescription ?? "Something went wrong. Please try again", title: "Error!")
      }
    }
    
    restaurantViewModel.updatedOnRestaurantListFetched = { error in
      if error == nil {
        SVProgressHUD.dismiss()
        if self.restaurantViewModel.restaurantListFeed.count > 0 {
          self.tableView.reloadData()
        } else {
          self.tableView.isHidden = true
          self.showAlert(message: "No Data Found")
        }
      } else {
        self.showAlert(message: error?.localizedDescription ?? "Something went wrong. Please try again", title: "Error!")
      }
    }
    
    bankViewModel.updatedOnBankDeleted = { error, status in
      if error == nil {
        SVProgressHUD.dismiss()
        if status {
          self.showAlert(message: "Bank deleted Successfully", title: "Yeah!")
        }
      } else {
        self.showAlert(message: error?.localizedDescription ?? "Something went wrong. Please try again", title: "Error!")
      }
    }
    
    restaurantViewModel.updatedOnRestaurantRemoved = { error, status in
      if error == nil {
        SVProgressHUD.dismiss()
        if status {
          self.showAlert(message: "Restaurant deleted Successfully", title: "Yeah!")
        }
      } else {
        self.showAlert(message: error?.localizedDescription ?? "Something went wrong. Please try again", title: "Error!")
      }
    }
  }
  
  @IBAction func tappedAddNewButton(_ sender: UIButton) {
    if setTitle == "Bank" {
      let controller = AppFunction.shared.viewControllerWith(AddBankViewController.storyboardIdentifier) as! AddBankViewController
      controller.title = "Add ".appending(setTitle)
      navigationController?.pushViewController(controller, animated: true)
    } else {
      let controller = AppFunction.shared.viewControllerWith(AddRestaurantViewController.storyboardIdentifier) as! AddRestaurantViewController
      controller.title = "Add ".appending(setTitle)
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @IBAction func tappedSearchButton(_ sender: UIButton) {
    let controller = AppFunction.shared.viewControllerWith(SearchViewController.storyboardIdentifier) as! SearchViewController
    controller.setTitle = setTitle
    if setTitle == "Bank" {
      controller.bankData = bankViewModel.bankListFeed
    } else {
      controller.resData = restaurantViewModel.restaurantListFeed
    }
    navigationController?.pushViewController(controller, animated: true)
  }
}

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  setTitle == "Bank" ? bankViewModel.bankListFeed.count : restaurantViewModel.restaurantListFeed.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
    cell.delegate = self
    let headTitle = setTitle == "Bank" ? bankViewModel.bankListFeed[indexPath.row].name : restaurantViewModel.restaurantListFeed[indexPath.row].name
    let subtitle = setTitle == "Bank" ? bankViewModel.bankListFeed[indexPath.row].branchName : restaurantViewModel.restaurantListFeed[indexPath.row].address
    let city = setTitle == "Bank" ? bankViewModel.bankListFeed[indexPath.row].city
      : restaurantViewModel.restaurantListFeed[indexPath.row].city
    let state = setTitle == "Bank" ? bankViewModel.bankListFeed[indexPath.row].state : restaurantViewModel.restaurantListFeed[indexPath.row].state
    cell.configureCell(title: headTitle ?? "", subTitle: subtitle ?? "", city: city ?? "", state: state ?? "")
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
  }
}

//MARK: - UITableViewDelegate, SwipeTableViewCellDelegate
extension ListViewController: UITableViewDelegate, SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if setTitle == "Bank" {
      let controller = AppFunction.shared.viewControllerWith(AddBankViewController.storyboardIdentifier) as! AddBankViewController
      controller.bankData = bankViewModel.bankListFeed[indexPath.row]
      controller.title = "Edit ".appending(setTitle).appending(" Info")
      navigationController?.pushViewController(controller, animated: true)
    } else {
      let controller = AppFunction.shared.viewControllerWith(AddRestaurantViewController.storyboardIdentifier) as! AddRestaurantViewController
      controller.resData = restaurantViewModel.restaurantListFeed[indexPath.row]
      controller.title = "Edit ".appending(setTitle).appending(" Info")
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    if orientation == .right {
      let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete a record?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (alert) in
          if self.setTitle == "Bank" {
            self.bankViewModel.removeBank(id: self.bankViewModel.bankListFeed[indexPath.row].id)
            self.bankViewModel.bankListFeed.remove(at: indexPath.row)
          } else {
            self.restaurantViewModel.removeRestaurant(id: self.restaurantViewModel.restaurantListFeed[indexPath.row].id)
            self.restaurantViewModel.restaurantListFeed.remove(at: indexPath.row)
          }
          tableView.deleteRows(at: [indexPath], with: .fade)
          tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
      }
      configure(action: delete, with: .trash)
      return [delete]
    }
    return [SwipeAction]()
  }
  
  func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
    action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
    action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
    
    switch buttonStyle {
    case .backgroundColor:
      action.backgroundColor = descriptor.color(forStyle: buttonStyle)
    case .circular:
      action.backgroundColor = .white
      action.textColor = descriptor.color(forStyle: buttonStyle)
      action.font = .systemFont(ofSize: 13)
      action.transitionDelegate = ScaleTransition.default
    }
  }
}
