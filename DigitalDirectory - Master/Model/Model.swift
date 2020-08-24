//
//  Model.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 23/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import Foundation

//MARK: - Bank
struct Bank: Codable {
  var id: String
  var name: String?
  var branchName: String?
  var branchCode: Int?
  var ifscCode: String?
  var address: String?
  var city: String?
  var state: String?
  var pincode: Int?
  var facility: String?
  
  private enum CodingKeys: String, CodingKey {
    case id, name, branchName, branchCode, ifscCode, address, city, state, pincode, facility
  }
  
  func removeField() -> [String: Any] {
    var data = [String: Any]()
    for (key, val) in self.toJSON()! {
      if key != "id" {
        data[key] = val
      }
    }
    return data
  }
}

//MARK: - Restaurant
struct Restaurant: Codable {
  var id: String
  var name: String?
  var rating: Float?
  var about: String?
  var address: String?
  var city: String?
  var state: String?
  var pincode: Int?
  var facility: String?
  
  private enum CodingKeys: String, CodingKey {
    case id, name, rating, about, address, city, state, pincode, facility
  }
  
  func removeField() -> [String: Any] {
    var data = [String: Any]()
    for (key, val) in self.toJSON()! {
      if key != "id" {
        data[key] = val
      }
    }
    return data
  }
}
