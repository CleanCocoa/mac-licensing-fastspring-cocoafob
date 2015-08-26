import Cocoa
import XCTest
import MyNewApp

class LicenseProviderTests: XCTestCase {

    var licenseProvider: LicenseProvider!
    
    let trialProviderDouble = TestTrialProvider()
    let clockDouble = TestClock()
    let userDefaultsDouble: TestUserDefaults = TestUserDefaults()

    override func setUp() {
        
        super.setUp()
        
        // No need to set the double on licenseProvider because 
        // its property is lazily loaded during test cases later.
        UserDefaults.setSharedInstance(UserDefaults(userDefaults: userDefaultsDouble))
        
        licenseProvider = LicenseProvider(trialProvider: trialProviderDouble, clock: clockDouble)
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

    func testObtainingCurrentLicense_WithEmptyDefaults_NoTrialPeriod_ReturnsTrialUp() {
        
        let licenseInfo = licenseProvider.currentLicense
        
        let trialIsUp: Bool
        
        switch licenseInfo {
        case .TrialUp: trialIsUp = true
        default: trialIsUp = false
        }
        
        XCTAssert(trialIsUp)
    }
    
    func testObtainingCurrentLicense_WithEmptyDefaults_ActiveTrialPeriod_ReturnsOnTrial() {
        
        let endDate = NSDate()
        let expectedPeriod = TrialPeriod(startDate: NSDate(), endDate: NSDate())
        clockDouble.testDate = endDate.dateByAddingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let licenseInfo = licenseProvider.currentLicense
        
        switch licenseInfo {
        case let .OnTrial(trialPeriod): XCTAssertEqual(trialPeriod, expectedPeriod)
        default: XCTFail("expected to be OnTrial")
        }
    }
    
    func testObtainingCurrentLicense_WithEmptyDefaults_PassedTrialPeriod_ReturnsTrialUp() {
        
        let endDate = NSDate()
        let expectedPeriod = TrialPeriod(startDate: NSDate(), endDate: NSDate())
        clockDouble.testDate = endDate.dateByAddingTimeInterval(100)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let licenseInfo = licenseProvider.currentLicense
        let trialIsUp: Bool
        
        switch licenseInfo {
        case .TrialUp: trialIsUp = true
        default: trialIsUp = false
        }
        
        XCTAssert(trialIsUp)
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
    
    class TestTrialProvider: TrialProvider {
        
        var testTrialPeriod: TrialPeriod?
        override var currentTrialPeriod: TrialPeriod? {
            
            return testTrialPeriod
        }
    }
    
    class TestClock: KnowsTimeAndDate {
        
        var testDate: NSDate!
        func now() -> NSDate {
            
            return testDate
        }
    }
}

