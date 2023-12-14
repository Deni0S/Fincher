import SwiftUI
import UIKit

final class DetailsScreenViewController: UIViewController {
    enum Const: String {
        case cell = "DetailsScreenCell"
    }

    private let closeButton = UIButton()
    private let chartsView = UIView()
    private let tableView = UITableView()
    var viewModel: DetailsScreenViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension DetailsScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel?.monthData.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cell.rawValue,
            for: indexPath as IndexPath) as? DetailsScreenCell,
              let item = viewModel?.monthData[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.configure(item: item)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        120
    }
}

private extension DetailsScreenViewController {
    func setupView() {
        addCloseButton()
        addChartView()
        addTableView()
    }

    func addCloseButton() {
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        closeButton.setTitle("  Закрыть  ", for: .normal)
        closeButton.backgroundColor = .systemGroupedBackground
        closeButton.setTitleColor(.label, for: .normal)
        closeButton.layer.cornerRadius = 14

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc
    func closeButtonTap() {
        dismiss(animated: true)
    }

    func addChartView() {
        view.addSubview(chartsView)
        chartsView.backgroundColor = .systemGroupedBackground

        chartsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartsView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            chartsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [self] in
            let childView = UIHostingController(rootView: DetailsChartView(charts: viewModel?.chartData ?? []))
            addChild(childView)
            childView.view.frame = chartsView.frame
            chartsView.addSubview(childView.view)
            childView.didMove(toParent: self)
        }
    }

    func addTableView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            DetailsScreenCell.self,
            forCellReuseIdentifier: Const.cell.rawValue)
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
