// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class TrialWriterTests: XCTestCase {

    func testStoring_DelegatesToUserDefaults() {
        
        // Given
        let writer = TrialWriter()
        let userDefaultsDouble = TestUserDefaults()
        writer.userDefaults = userDefaultsDouble
        let startDate = Date(timeIntervalSince1970: 4567)
        let endDate = Date(timeIntervalSince1970: 121314)
        let trialPeriod = TrialPeriod(startDate: startDate, endDate: endDate)
        
        // When
        writer.store(trialPeriod: trialPeriod)
        
        // Then
        let changedDefaults = userDefaultsDouble.didSetObjectsForKeys
        XCTAssertNotNil(changedDefaults)
        if let changedDefaults = changedDefaults {
            XCTAssertEqual(changedDefaults[TrialPeriod.DefaultsKey.startDate.rawValue], startDate)
            XCTAssertEqual(changedDefaults[TrialPeriod.DefaultsKey.endDate.rawValue], endDate)
        }
    }

    
    // MARK: - 
    
    class TestUserDefaults: NullUserDefaults {
        
        var didSetObjectsForKeys: [String : Date]?
        override func set(_ value: Any?, forKey key: String) {
            
            if didSetObjectsForKeys == nil {
                didSetObjectsForKeys = [String : Date]()
            }
            
            didSetObjectsForKeys![key] = value as? Date
        }
    }
}
