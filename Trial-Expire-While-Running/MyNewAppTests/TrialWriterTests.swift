// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class TrialWriterTests: XCTestCase {

    let userDefaultsDouble: TestUserDefaults = TestUserDefaults()
    
    override func setUp() {
        
        super.setUp()
        
        // No need to set the double on TrialWriter because
        // its property is lazily loaded during test cases later.
        MyNewApp.UserDefaults.sharedInstance = MyNewApp.UserDefaults(userDefaults: userDefaultsDouble)
    }
    
    override func tearDown() {
        
        MyNewApp.UserDefaults.resetSharedInstance()
        
        super.tearDown()
    }
    

    func testStoring_DelegatesToUserDefaults() {
        
        // Given
        let writer = TrialWriter()
        let startDate = Date(timeIntervalSince1970: 4567)
        let endDate = Date(timeIntervalSince1970: 121314)
        let trialPeriod = TrialPeriod(startDate: startDate, endDate: endDate)
        
        // When
        writer.store(trialPeriod: trialPeriod)
        
        // Then
        let changedDefaults = userDefaultsDouble.didSetObjectsForKeys
        XCTAssert(hasValue(changedDefaults))
        
        if let changedDefaults = changedDefaults {
            
            XCTAssert(changedDefaults[TrialPeriod.UserDefaultsKeys.StartDate.rawValue] == startDate)
            XCTAssert(changedDefaults[TrialPeriod.UserDefaultsKeys.EndDate.rawValue] == endDate)
        }
    }

    
    // MARK: - 
    
    class TestUserDefaults: NullUserDefaults {
        
        var didSetObjectsForKeys: [String : Date]?
        override func set(_ value: Any?, forKey key: String) {
            
            if !hasValue(didSetObjectsForKeys) {
                didSetObjectsForKeys = [String : Date]()
            }
            
            didSetObjectsForKeys![key] = value as? Date
        }
    }
}
