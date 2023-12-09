import XCTest
@testable import Fincher

final class FincherTests: XCTestCase {

    let viewModel = MainViewModel()
    var paymentsCalendar: [Payments] = []
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testCalculateAnnuitentPayments() throws {
        // given
        viewModel.amountOfCredit = 1000
        viewModel.interestRate = 10
        viewModel.creditTerm = 1
        // when
        let result = viewModel.calculateAnnuitentPayments()
        // then
        XCTAssertEqual(String(format: "%.2f", result),"54.99")
    }
    
    func testCalculateDiffPayments() throws {
        //given
        viewModel.amountOfCredit = 1000
        viewModel.interestRate = 10
        viewModel.creditTerm = 1
        //when
        var result: (Double, Double, Double) = (0, 0, 0)
        result = viewModel.calculateDiffPayments()
        //Then
        XCTAssertEqual(String(format: "%.2f", result.2),"54.17")
    }
    
    func testCalculateTermPayments() throws {
        //given
        viewModel.amountOfCredit = 1000
        viewModel.interestRate = 10
        viewModel.paymentSetted = 100
        //when
        var result: (Int, Double) = (0, 0)
        result = viewModel.calculateTermPayments()
        // Then
        XCTAssertEqual(String(format: "%.2f", result.1),"48.58")
        
    }
    
    func testCalculateMaxCredit() throws {
        // given
        viewModel.interestRate = 10
        viewModel.creditTerm = 1
        viewModel.paymentSetted = 1000
        // when
        var result: (Double, Double) = (0, 0)
        result = viewModel.calculateMaxCredit()
        //then
        // Then
        XCTAssertEqual(String(format: "%.2f", result.1),"625.49")
    }
}
