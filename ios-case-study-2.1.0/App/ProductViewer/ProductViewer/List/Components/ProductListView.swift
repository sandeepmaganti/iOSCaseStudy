//
//  ProductListComponent.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

final class ProductListView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var bTwoButton: UIButton!
}

extension ProductListView: ReusableNib {
    @nonobjc static let nibName = "ProductListView"
    @nonobjc static let reuseID = "ProductListViewIdentifier"

    @nonobjc func prepareForReuse() {
        
    }
}
