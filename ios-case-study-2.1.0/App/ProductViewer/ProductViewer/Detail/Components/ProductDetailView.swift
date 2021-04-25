//
//  ProductDetailView.swift
//  ProductViewer
//
//  Created by Maganti, Sandeep on 24/04/21.
//  Copyright © 2021 Target. All rights reserved.
//

import Tempo

struct Constants {
    static let addToCart = "add to cart"
    static let addToList = "add to list"
}

final class ProductDetailView: UIView, TempoPresenter {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var addToListButton: UIButton!
    

    func present(_ viewState: ProductDetailViewState) {
        showView()
        addToCartButton.setTitle(Constants.addToCart, for: .normal)
        addToListButton.setTitle(Constants.addToList, for: .normal)
        addToCartButton.setCornerRadius(radius: 5)
        addToListButton.setCornerRadius(radius: 5)
        productDescriptionLabel.text = viewState.product.description
        productPriceLabel.font = .boldSystemFont(ofSize: 32)
        productPriceLabel.text = viewState.product.regularPrice?.displayString
        if let imageURL = viewState.product.imageUrl {
           productImageView.imageFromServerURL(imageURL, placeHolder: UIImage(named: "1"))
        }
    }

    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: {
            view.isHidden = hidden
            if hidden {
                self.removeFromSuperview()
            } else {
                if let window = UIApplication.shared.windows.first {
                    self.frame = window.bounds
                    window.addSubview(self)
                    window.bringSubviewToFront(self)
                }
            }
        })
    }

    func showView() {
        setView(view: self, hidden: false)
    }
    @IBAction func onBackButtonTap(_ sender: Any) {
        setView(view: self, hidden: true)
    }
}

extension ProductDetailView: ReusableNib {
    @nonobjc static let nibName = "ProductDetailView"
    @nonobjc static let reuseID = "ProductDetailViewIdentifier"

    @nonobjc func prepareForReuse() {

    }
}
