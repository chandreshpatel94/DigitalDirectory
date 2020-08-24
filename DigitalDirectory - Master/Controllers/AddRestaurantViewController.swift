//
//  AddRestaurantViewController.swift
//  DigitalDirectory
//
//  Created by CHANDRESH on 22/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit
import SVProgressHUD
import SkyFloatingLabelTextField

class AddRestaurantViewController: BaseViewController {
  
  
  @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var pincodeTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var aboutTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var ratingTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var collectionView: UICollectionView!
  
  fileprivate var viewModel = RestaurantViewModel()
  fileprivate var cellWidth: CGFloat {
    return (collectionView.frame.width) / 3
  }
  fileprivate var cellHeight: CGFloat {
    return 50
  }
  fileprivate var contentInset: UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  var resData: Restaurant?
  var facilityIndex = [Int]()
  let facilityList = ["A.C.", "Parcel", "Tiffin", "Veg Food", "Non-Veg Food"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.contentInset = contentInset
    collectionView.register(UINib(nibName: FacilityCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: FacilityCollectionViewCell.reuseIdentifier)
    setupUI()
    setData()
    setupViewModel()
  }
  
  private func setupUI() {

  }
  
  private func setData() {
    if let data = resData {
      nameTextField.text = data.name
      aboutTextField.text = data.about
      addressTextField.text = data.address
      cityTextField.text = data.city
      stateTextField.text = data.state
      if let pCode = data.pincode {
        pincodeTextField.text = String(describing: pCode)
      }
      if let rat = data.rating {
        ratingTextField.text = String(describing: rat )
      }
      if let fac = data.facility {
        facilityIndex = fac.components(separatedBy: ",").compactMap { Int($0) }
      }
    }
  }
  
  private func setupViewModel() {
    viewModel.updatedOnRestaurantAdded = { error, status in
      if error == nil {
        SVProgressHUD.dismiss()
        if status {
          let alertController = UIAlertController(title: "Yeah!!!", message: "Restaurant Added Successfully", preferredStyle: .alert)
          let OKAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.navigationController?.popViewController(animated: true)
          }
          alertController.addAction(OKAction)
          self.present(alertController, animated: true, completion: nil)
        }
      } else {
        self.showAlert(message: error?.localizedDescription ?? "Something went wrong. Please try again", title: "Error!")
      }
    }
    
    viewModel.updatedOnRestaurantUpdated = { error, status in
      if error == nil {
        SVProgressHUD.dismiss()
        if status {
          let alertController = UIAlertController(title: "Yeah!!!", message: "Restaurant updates Successfully", preferredStyle: .alert)
          let OKAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.navigationController?.popViewController(animated: true)
          }
          alertController.addAction(OKAction)
          self.present(alertController, animated: true, completion: nil)
        }
      } else {
        self.showAlert(message: error?.localizedDescription ?? "Something went wrong. Please try again", title: "Error!")
      }
    }
  }
  @IBAction func tappedRatingUpButton(_ sender: Any) {
    if let str = ratingTextField.text {
      if (str as NSString).floatValue < 5.0 {
        ratingTextField.text = String(describing: (str as NSString).floatValue + 0.5)
      }
    }
  }
  @IBAction func tappedRatingDownButton(_ sender: Any) {
    if let str = ratingTextField.text {
      if (str as NSString).floatValue > 0.0 {
        ratingTextField.text = String(describing: (str as NSString).floatValue - 0.5)
      }
    }
  }
  
  @IBAction func tappedSaveButton(_ sender: Any) {
    SVProgressHUD.show()
    if !(nameTextField.text?.isEmpty ?? false) {
      if !(addressTextField.text?.isEmpty ?? false) {
        if !(cityTextField.text?.isEmpty ?? false) {
          if !(stateTextField.text?.isEmpty ?? false) {
            if !(pincodeTextField.text?.isEmpty ?? false) {
              if !(aboutTextField.text?.isEmpty ?? false) {
                if !(ratingTextField.text?.isEmpty ?? false) {
                if facilityIndex.count != 0 {
                  let data = Restaurant(id: "", name: nameTextField.text, rating: ratingTextField.text?.floatValue, about: aboutTextField.text, address: addressTextField.text, city: cityTextField.text, state: stateTextField.text, pincode: Int(pincodeTextField.text ?? "0"), facility: facilityIndex.map{String($0)}.joined(separator: ",") )
                  if let rData = resData {
                    viewModel.updateRestaurant(id: rData.id, item: data)
                  } else {
                    viewModel.addRestaurant(item: data)
                  }
                } else { showAlert(message: "Please select atleast one facility", title: "Error!") }
                }
              } else {showAlert(message: "Please enter about restaurant", title: "Error!")}
            } else { showAlert(message: "Please enter pincode", title: "Error!") }
          } else { showAlert(message: "Please enter state name", title: "Error!") }
        } else { showAlert(message: "Please enter city name", title: "Error!") }
      } else { showAlert(message: "Please enter address", title: "Error!") }
    } else  { showAlert(message: "Please enter Bank name", title: "Error!") }
  }
}

//MARK: - UICollectionViewDataSource
extension AddRestaurantViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return facilityList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FacilityCollectionViewCell.reuseIdentifier, for: indexPath) as! FacilityCollectionViewCell
    var status = false
    for i in facilityIndex {
      if i == indexPath.row {
        status = true
      }
    }
    cell.configureCell(item: facilityList[indexPath.row], isCheck: status)
    return cell
  }
}

//MARK: - UICollectionViewDelegate
extension AddRestaurantViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if facilityIndex.count > 0 {
      if !facilityIndex.contains(indexPath.row) {
        facilityIndex.append(indexPath.row)
      } else {
        for (index, val) in facilityIndex.enumerated() {
          if val == indexPath.row {
            facilityIndex.remove(at: index)
          }
        }
      }
    } else {
      facilityIndex.append(indexPath.row)
    }
    collectionView.reloadData()
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AddRestaurantViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
