//
//  ListCoordinator.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation
import Tempo

/*
 Coordinator for the product list
 */
class ListCoordinator: TempoCoordinator {
    
    // MARK: Presenters, view controllers, view state.
    
    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var viewState: ListViewState {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        for presenter in presenters {
            presenter.present(viewState)
        }
    }
    
    let dispatcher = Dispatcher()
    
    lazy var viewController: ListViewController = {
        return ListViewController.viewControllerFor(coordinator: self)
    }()
    
    // MARK: Init
    
    required init() {
        viewState = ListViewState(listItems: [])
        updateState()
        registerListeners()
    }
    
    // MARK: ListCoordinator
    
    fileprivate func registerListeners() {
        dispatcher.addObserver(ListItemPressed.self) { e in
            if let customView =  UINib(nibName: ProductDetailView.nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ProductDetailView {
                let coordinator = ProductDetailCoordinator(product: e.item)
                coordinator.presenters = [customView]
            }
        }
    }

    func updateState() {
        let networkActivity = NetworkActivity()
        let webservice = WebService(networkActivity: networkActivity)
        networkActivity.observe { state in
            switch state {
            ///TBD
            case .show:
                print("Show loader")
            case .hide:
                print("Hide loader")
            }
        }

        webservice.request(ProductsEndpoint.all) { (result: Result<Products, NetworkStackError>) in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let products):
                    self.viewState.listItems = (products.products?.map{ (product) in
                        ListItemViewState(product: product)
                    })! as [TempoViewStateItem]
            }
        }
    }
} 
