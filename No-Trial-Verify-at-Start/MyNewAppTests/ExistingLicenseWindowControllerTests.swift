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
    

    // MARK: Nib Loading
    
    func testLicenseeTextField_IsConnected() {
        
        XCTAssert(hasValue(controller.licenseeTextField))
    }
    
    func testLicenseCodeTextField_IsConnected() {
        
        XCTAssert(hasValue(controller.licenseCodeTextField))
    }
    
    func testRegisterButton_IsConnected() {
        
        XCTAssert(hasValue(controller.registerButton))
    }

    func testRegisterButton_IsWiredToAction() {
        
        XCTAssert(controller.registerButton?.action == Selector("register:"))
    }
    
    
    // MARK: Registering
    
    func testRegistering_DelegatesToEventHandler() {
        
        // Given
        let eventHandlerDouble = TestEventHandler()
        controller.eventHandler = eventHandlerDouble
        
        let name = "a name"
        let licenseCode = "123-key"
        controller.licenseeTextField?.stringValue = name
        controller.licenseCodeTextField?.stringValue = licenseCode
        
        // When
        controller.register(self)
        
        // Then
        let registerParams = eventHandlerDouble.didRegisterWith
        XCTAssert(hasValue(registerParams))
        
        if let registerParams = registerParams {
            XCTAssertEqual(registerParams.name, name)
            XCTAssertEqual(registerParams.licenseCode, licenseCode)
        }
    }
    
    
    // MARK: - 
    
    class TestEventHandler: HandlesRegistering {
        
        var didRegisterWith: (name: String, licenseCode: String)?
        func register(name: String, licenseCode: String) {
            
            didRegisterWith = (name, licenseCode)
        }
    }
}
