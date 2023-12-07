final class DetailsScreenAssembly {
    func assemble(_ payments: DetailsScreenViewModel.Payments) -> DetailsScreenViewController {
        let controller = DetailsScreenViewController()
        let viewModel = DetailsScreenViewModel(payments)
        controller.viewModel = viewModel
        return controller
    }
}
