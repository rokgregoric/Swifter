//
//  UICollectionViewCellExtensions.swift
//
//  Created by Rok Gregoric on 01/03/2018.
//  Copyright © 2018 GFA. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
  class func dequeueReusableCell(identifier: String? = nil, for indexPath: IndexPath, on collectionView: UICollectionView) -> Self {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier ?? self.identifier, for: indexPath)
    return castToSelf(cell)
  }

  class func register(identifier: String? = nil, on collectionView: UICollectionView) {
    collectionView.register(nib(), forCellWithReuseIdentifier: identifier ?? self.identifier)
  }
}
