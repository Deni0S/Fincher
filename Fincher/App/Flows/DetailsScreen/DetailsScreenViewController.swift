import UIKit

final class DetailsScreenViewController: UIViewController {

    private let tableView = UITableView()
    var viewModel: DetailsScreenViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension DetailsScreenViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        viewModel.monthData.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "DetailsScreenCell",
            for: indexPath as IndexPath) as! DetailsScreenCell
        cell.configure(viewModel.monthData[indexPath.row])
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        120
    }
}

private extension DetailsScreenViewController {

    func setupView() {
        addTableView()
    }

    func addTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            DetailsScreenCell.self,
            forCellReuseIdentifier: "DetailsScreenCell")
        view.addSubview(tableView)
        setupTableViewConstraint()
    }

    func setupTableViewConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
