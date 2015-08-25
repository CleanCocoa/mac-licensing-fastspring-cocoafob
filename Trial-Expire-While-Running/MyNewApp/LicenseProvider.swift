import Foundation

public class LicenseProvider {
    
    let trialProvider: TrialProvider
    let clock: KnowsTimeAndDate
    
    public init(trialProvider: TrialProvider, clock: KnowsTimeAndDate) {
        
        self.trialProvider = trialProvider
        self.clock = clock
    }
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public var currentLicense: LicenseInformation {
        
        if let license = self.license() {
                
            return .Registered(license)
        }
        
        if let trial = self.trial() where !trial.ended(clock) {
            
            return .OnTrial(trial)
        }
        
        return .TrialUp
    }
    
    func license() -> License? {
        
        if let name = userDefaults.stringForKey("\(License.UserDefaultsKeys.Name)"),
            licenseCode = userDefaults.stringForKey("\(License.UserDefaultsKeys.LicenseCode)") {
                
                return License(name: name, licenseCode: licenseCode)
        }
        
        return .None
    }

    func trial() -> TrialPeriod? {
        
        return trialProvider.currentTrialPeriod
    }
}
