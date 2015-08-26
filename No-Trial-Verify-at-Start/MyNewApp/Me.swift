// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation
import AddressBook

/// Wrapper around `ABPerson` to expose properties used by the FastSpring store
/// in a useful manner with proper types.
class Me {
    
    let person: ABPerson
    
    convenience init() {
        
        self.init(person: ABAddressBook.sharedAddressBook().me())
    }
    
    init(person: ABPerson) {
        
        self.person = person
    }
    
    static let Unknown = ""
    
    var firstName: String {
        
        if let firstName = person.valueForProperty(kABFirstNameProperty) as? String {
            
            return firstName
        }
        
        return Me.Unknown
    }
    
    var lastName: String {
        
        if let lastName = person.valueForProperty(kABLastNameProperty) as? String {
            
            return lastName
        }
        
        return Me.Unknown
    }
    
    var organization: String {
        
        if let lastName = person.valueForProperty(kABLastNameProperty) as? String {
            
            return lastName
        }
        
        return Me.Unknown
    }
    
    var primaryEmail: String {
        
        if let allEmails = person.valueForProperty(kABEmailProperty) as? ABMultiValue,
            primaryEmail = allEmails.valueAtIndex(allEmails.indexForIdentifier(allEmails.primaryIdentifier())) as? String {
                
                return primaryEmail
        }
        
        return Me.Unknown
    }
    
    var primaryPhone: String {
        
        if let allPhones = person.valueForProperty(kABPhoneProperty) as? ABMultiValue,
            primaryPhone = allPhones.valueAtIndex(allPhones.indexForIdentifier(allPhones.primaryIdentifier())) as? String {
                
                return primaryPhone
        }
        
        return Me.Unknown
    }
}
