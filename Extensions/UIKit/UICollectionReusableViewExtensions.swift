//
//  UICollectionReusableViewExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
  class func dequeueReusableSupplementaryView(of kind: String, identifier: String? = nil, for indexPath: IndexPath, on collectionView: UICollectionView) -> Self {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier ?? self.identifier, for: indexPath)
    return castToSelf(view)
  }

  class func register(for kind: String, identifier: String? = nil, on collectionView: UICollectionView) {
    collectionView.register(nib(), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier ?? self.identifier)
  }
}
