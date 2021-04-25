import Tempo

class ProductDetailCoordinator: TempoCoordinator {

    // MARK: Presenters, view controllers, view state.

    var presenters = [TempoPresenterType]() {
        didSet {
            updateUI()
        }
    }

    fileprivate var viewState: ProductDetailViewState {
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

    // MARK: Init

    required init(product: Product) {
        viewState = ProductDetailViewState(product: product)
        updateState(product: product)
    }

    func updateState(product: Product) {
        viewState.product = product
    }
}
