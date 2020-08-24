//
//  BankViewModel.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 23/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import Foundation

class BankViewModel {
  
  var bankListFeed = [Bank]()
  typealias BankFeedFetchCallback = (_ error: Error?) -> Void
  typealias BankDataAddCallback = (_ error: Error?, _ status: Bool) -> Void
  typealias BankDataDeleteCallback = (_ error: Error?, _ status: Bool) -> Void
  typealias BankDataUpadteCallback = (_ error: Error?, _ status: Bool) -> Void
  var updatedOnBankListFetched: BankFeedFetchCallback?
  var updatedOnBankAdded: BankDataAddCallback?
  var updatedOnBankDeleted: BankDataDeleteCallback?
  var updatedOnBankUpdated: BankDataUpadteCallback?
  
  private(set) var isLoading = false
  private var dataProvider = BankDataProvider()
  
  func fetchBankList() {
    isLoading = true
    dataProvider.fetchData()
      .done({ data in
        self.isLoading = false
        self.bankListFeed = data
        self.updatedOnBankListFetched!(nil)
      })
      .catch { error in
        self.isLoading = false
        self.updatedOnBankListFetched!(error)
    }
  }
  
  func addBank(item: Bank) {
    isLoading = true
    dataProvider.addData(data: item)
      .done({ data in
        self.isLoading = false
//        self.bankListFeed = data
        self.updatedOnBankAdded!(nil, data)
      })
      .catch { error in
        self.isLoading = false
        self.updatedOnBankAdded!(error, false)
    }
  }
  
    func removeBank(id: String) {
      isLoading = true
      dataProvider.removeData(id: id)
        .done({ data in
          self.isLoading = false
  //        self.bankListFeed = data
          self.updatedOnBankDeleted!(nil, data)
        })
        .catch { error in
          self.isLoading = false
          self.updatedOnBankDeleted!(error, false)
      }
    }
  
  func updateBank(id: String, item: Bank) {
      isLoading = true
    dataProvider.updateData(id: id, data: item)
        .done({ data in
          self.isLoading = false
  //        self.bankListFeed = data
          self.updatedOnBankUpdated!(nil, data)
        })
        .catch { error in
          self.isLoading = false
          self.updatedOnBankUpdated!(error, false)
      }
    }
}
