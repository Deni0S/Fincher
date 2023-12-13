import XCTest
@testable import Fincher

final class FincherTests: XCTestCase {

    let viewModel = MainViewModel()
    var paymentsCalendar: [Payments] = []
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    func testCalculateAnnuitentPayments() throws {
        viewModel.amountOfCredit = 1000
        viewModel.interestRate = 10
        viewModel.creditTerm = 1
        let result = try! viewModel.calculateAnnuitentPayments()
        XCTAssertEqual(String(format: "%.2f", result),"54.99")
    }
    
    func testCalculateDiffPayments() throws {
        viewModel.amountOfCredit = 1000
        viewModel.interestRate = 10
        viewModel.creditTerm = 1
        var result: (Double, Double, Double) = (0, 0, 0)
        result = try! viewModel.calculateDiffPayments()
        XCTAssertEqual(String(format: "%.2f", result.2),"54.17")
    }
    
    func testCalculateTermPayments() throws {
        viewModel.amountOfCredit = 1000
        viewModel.interestRate = 10
        viewModel.paymentSetted = 100
        var result: (Int, Double) = (0, 0)
        result = try! viewModel.calculateTermPayments()
        XCTAssertEqual(String(format: "%.2f", result.1),"48.58")
    }
    
    func testCalculateMaxCredit() throws {
        viewModel.interestRate = 10
        viewModel.creditTerm = 1
        viewModel.paymentSetted = 1000
        var result: (Double, Double) = (0, 0)
        result = try! viewModel.calculateMaxCredit()
        XCTAssertEqual(String(format: "%.2f", result.1),"625.49")
    }
}
