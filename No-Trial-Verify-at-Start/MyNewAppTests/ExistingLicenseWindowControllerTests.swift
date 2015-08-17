import Cocoa
import XCTest
import MyNewApp

class ExistingLicenseWindowControllerTests: XCTestCase {

    var controller: ExistingLicenseViewController!
    
    override func setUp() {
        
        super.setUp()
        
        let windowController = LicenseWindowController()
        loadWindow(windowController)
        
        controller = windowController.existingLicenseViewController
    }
    
    override func tearDown() {
        
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
