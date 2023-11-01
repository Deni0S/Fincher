
final class DetailsScreenAssembly {

    func assemble(_ monthData: [DetailsScreenViewData]) -> DetailsScreenViewController {
        let controller = DetailsScreenViewController()
        let viewModel = DetailsScreenViewModel(monthData)
        controller.viewModel = viewModel
        return controller
    }
}
