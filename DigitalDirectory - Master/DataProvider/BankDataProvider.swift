//
//  BankDataProvider.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 23/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import Foundation
import PromiseKit

class BankDataProvider {
  
  func fetchData() -> Promise<[Bank]> {
    return Promise { seal in
      FSHelper.shared
        .getCollectionReference(collection: .k_bank)
        .getDocuments(completion: { (snapshot, error) in
          guard error == nil else {
            seal.reject(error!)
            print(error)
            return
          }
          
          if let items = snapshot?.documents
            .map({ (snapshot) -> Bank? in
              guard let data = snapshot.dataWithFieldIncluded(fieldName: "id") else {
                return nil
              }
              return Bank.deserialize(from: data)
            })
            .compactMap({
              return $0
            }) {
            seal.fulfill(items)
          } else {
            seal.fulfill([])
          }
        })
    }
  }
  
  func addData(data: Bank) -> Promise<Bool> {
    return Promise { seal in
      FSHelper.shared
        .getCollectionReference(collection: .k_bank)
        .addDocument(data: data.removeField()) { err in
          if let err = err {
            seal.reject(err)
          } else {
            seal.fulfill(true)
          }
      }
    }
  }
  
  func removeData(id: String) -> Promise<Bool> {
    return Promise { seal in
      FSHelper.shared
        .getCollectionReference(collection: .k_bank).document(id).delete() { err in
          if let err = err {
            seal.reject(err)
          } else {
            seal.fulfill(true)
          }
      }
    }
  }
  
  func updateData(id: String, data: Bank) -> Promise<Bool> {
    return Promise { seal in
      FSHelper.shared
        .getCollectionReference(collection: .k_bank)
        .document(id).setData(data.removeField())  { err in
          if let err = err {
            seal.reject(err)
          } else {
            seal.fulfill(true)
          }
      }
    }
  }
}
