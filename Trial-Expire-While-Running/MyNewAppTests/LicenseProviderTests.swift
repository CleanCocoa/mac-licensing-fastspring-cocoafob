import Cocoa
import XCTest
import MyNewApp

class LicenseProviderTests: XCTestCase {

    let licenseProvider = LicenseProvider()
    
    let userDefaultsDouble: TestUserDefaults = TestUserDefaults()

    override func setUp() {
        
        super.setUp()
        
        // No need to set the double on licenseProvider because 
        // its property is lazily loaded during test cases later.
        UserDefaults.setSharedInstance(UserDefaults(userDefaults: userDefaultsDouble))
    }
    
    override func tearDown() {
        
        UserDefaults.resetSharedInstance()
        
        super.tearDown()
    }

    func provideLicenseDefaults(name: String, licenseCode: String) {
        userDefaultsDouble.testValues = [
            License.UserDefaultsKeys.Name.rawValue : name,
            License.UserDefaultsKeys.LicenseCode.rawValue : licenseCode
        ]
    }
    
    
    // MARK: -
    // MARK: Empty Defaults, no License
    
    func testObtainingCurrentLicense_WithEmptyDefaults_QueriesDefaultsForName() {
        
        _ = licenseProvider.currentLicense
        
        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(contains(usedDefaultNames, License.UserDefaultsKeys.Name.rawValue))
        }
    }

    func testObtainingCurrentLicense_WithEmptyDefaults_ReturnsOnTrial() {
        
        let licenseInfo = licenseProvider.currentLicense
        
        let isOnTrial: Bool
        
        switch licenseInfo {
        case .OnTrial(_): isOnTrial = true
        default: isOnTrial = false
        }
        
        XCTAssert(isOnTrial)
    }
    
    
    // MARK: Existing Defaults, Registered
    
    func testObtainingCurrentLicense_WithDefaultsValues_QueriesDefaultsForNameAndKey() {
        
        provideLicenseDefaults("irrelevant name", licenseCode: "irrelevant key")
        
        _ = licenseProvider.currentLicense
        
        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(contains(usedDefaultNames, License.UserDefaultsKeys.Name.rawValue))
            XCTAssert(contains(usedDefaultNames, License.UserDefaultsKeys.LicenseCode.rawValue))
        }
    }

    func testObtainingCurrentLicense_WithDefaultsValues_ReturnsRegisteredWithInfo() {

        let name = "a name"
        let key = "a license key"
        provideLicenseDefaults(name, licenseCode: key)
        
        let licenseInfo = licenseProvider.currentLicense
        
        let license: License?
        
        switch licenseInfo {
        case let .Registered(foundLicense): license = foundLicense
        default: license = .None
        }
        
        XCTAssert(hasValue(license))
        
        if let license = license {
            
            XCTAssertEqual(license.name, name)
            XCTAssertEqual(license.licenseCode, key)
        }
    }
    
    
    // MARK: -
    
    class TestUserDefaults: NullUserDefaults {
        
        var testValues = [String : String]()
        var didCallStringForKeyWith: [String]?
        override func stringForKey(defaultName: String) -> String? {
            
            if !hasValue(didCallStringForKeyWith) {
                didCallStringForKeyWith = [String]()
            }
            
            didCallStringForKeyWith?.append(defaultName)
            
            return testValues[defaultName]
        }
    }
}

class NullUserDefaults: NSUserDefaults {
    
    override func registerDefaults(registrationDictionary: [NSObject : AnyObject]) {  }
    override func valueForKey(key: String) -> AnyObject? { return nil }
    override func setValue(value: AnyObject?, forKey key: String) {  }
}

