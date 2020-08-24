//
//  RestaurantViewModel.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 23/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import Foundation

class RestaurantViewModel {
  
  typealias RestaurantFeedFetchCallback = (_ error: Error?) -> Void
  typealias RestaurantDataAddCallback = (_ error: Error?, _ status: Bool) -> Void
  typealias RestaurantDataRemoveCallback = (_ error: Error?, _ status: Bool) -> Void
  typealias RestaurantDataUpdateCallback = (_ error: Error?, _ status: Bool) -> Void
  var updatedOnRestaurantListFetched: RestaurantFeedFetchCallback?
  var updatedOnRestaurantAdded: RestaurantDataAddCallback?
  var updatedOnRestaurantRemoved: RestaurantDataRemoveCallback?
  var updatedOnRestaurantUpdated: RestaurantDataUpdateCallback?
  var restaurantListFeed = [Restaurant]()
  
  private(set) var isLoading = false
  private var dataProvider = RestaurantDataProvider()
  
  func fetchRestaurantList() {
    isLoading = true
    dataProvider.fetchData()
      .done({ data in
        self.isLoading = false
        self.restaurantListFeed = data
        self.updatedOnRestaurantListFetched!(nil)
      })
      .catch { error in
        self.isLoading = false
        self.updatedOnRestaurantListFetched!(error)
    }
  }
  
  func addRestaurant(item: Restaurant) {
      isLoading = true
      dataProvider.addData(data: item)
        .done({ data in
          self.isLoading = false
  //        self.bankListFeed = data
          self.updatedOnRestaurantAdded!(nil, data)
        })
        .catch { error in
          self.isLoading = false
          self.updatedOnRestaurantAdded!(error, false)
      }
    }
  
    func removeRestaurant(id: String) {
      isLoading = true
      dataProvider.removeData(id: id)
        .done({ data in
          self.isLoading = false
  //        self.bankListFeed = data
          self.updatedOnRestaurantRemoved!(nil, data)
        })
        .catch { error in
          self.isLoading = false
          self.updatedOnRestaurantRemoved!(error, false)
      }
    }
  
  func updateRestaurant(id: String, item: Restaurant) {
      isLoading = true
    dataProvider.updateData(id: id, data: item)
        .done({ data in
          self.isLoading = false
  //        self.bankListFeed = data
          self.updatedOnRestaurantUpdated!(nil, data)
        })
        .catch { error in
          self.isLoading = false
          self.updatedOnRestaurantUpdated!(error, false)
      }
    }
}
