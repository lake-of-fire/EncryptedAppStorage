import Foundation
import Combine
import KeychainAccess
import SwiftUI

@propertyWrapper
public struct EncryptedAppStorage<Value: Codable>: DynamicProperty {
    private let publisher = PassthroughSubject<Value, Never>()
    @ObservedObject private var storage: KeychainStorage<Value>
    
    public var wrappedValue: Value {
        get { storage.value }
        
        nonmutating set {
            storage.value = newValue
            publisher.send(newValue)
        }
    }
    
    init(wrappedValue: Value, _ key: String) {
        storage = KeychainStorage(
            defaultValue: wrappedValue,
            for: key
        )
    }
    
    public var projectedValue: AnyPublisher<Value, Never> {
        publisher.eraseToAnyPublisher()
    }
}
