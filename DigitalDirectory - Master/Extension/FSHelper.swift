//
//  FSHelper.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 23/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

enum FSCollection: Int {
  case k_bank, k_restaurant
  
  var name: String {
    switch self {
    case .k_bank:
      return "Bank"
    case .k_restaurant:
      return "Restaurant"
    }
  }
}

class FSHelper {
  
  static let shared = FSHelper()

  func getInstance() -> Firestore {
    let ref: Firestore = Firestore.firestore()
    let settings = ref.settings
    settings.isPersistenceEnabled = true
    settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
    ref.settings = settings
    return ref
  }
  
  func getWriteBatch() -> WriteBatch {
    return getInstance().batch()
  }
  
  func getCollectionReference(collection: FSCollection) -> CollectionReference {
    return getInstance().collection(collection.name)
  }
  
  func getDocumentReference(collection: FSCollection, id: String) -> DocumentReference {
    return getCollectionReference(collection: collection).document(id)
  }
  
  func getSubCollectionReference(main: FSCollection, sub: FSCollection, id: String) -> CollectionReference {
    return getDocumentReference(collection: main, id: id).collection(sub.name)
  }
}

extension DocumentSnapshot {
  func dataWithFieldIncluded(fieldName: String) -> [String: Any]? {
    if var theData = self.data() {
      theData[fieldName] = self.documentID
      return theData
    }
    return nil
  }
}
