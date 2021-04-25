//
//  ProductListComponent.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//
import Tempo

struct ProductListComponent: Component {
    var dispatcher: Dispatcher?

    func prepareView(_ view: ProductListView, item: ListItemViewState) {
        // Called on first view or ProductListView
    }
    
    func configureView(_ view: ProductListView, item: ListItemViewState) {
        view.titleLabel.text = item.product.title
        view.priceLabel.text = item.product.regularPrice?.displayString
        if let imageURL = item.product.imageUrl {
            view.productImage.imageFromServerURL(imageURL, placeHolder: UIImage(named: "1"))
        }
        let title = item.product.aisle?.capitalized
        view.bTwoButton.setTitle(title, for: .normal)
        view.bTwoButton.addCircleRadius()
        view.orLabel.textColor = .gray
    }
    
    func selectView(_ view: ProductListView, item: ListItemViewState) {
        dispatcher?.triggerEvent(ListItemPressed.init(item: item.product))
    }
}

extension ProductListComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return 100.0
    }
}
