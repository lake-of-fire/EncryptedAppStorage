import Foundation
import Combine
import KeychainAccess

final class KeychainStorage<Value: Codable>: ObservableObject {
    var value: Value {
        set {
            objectWillChange.send()
            save(newValue)
        }
        get { fetch() }
    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let key: String
    private let defaultValue: Value
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private let keychain: Keychain

    init(defaultValue: Value, for key: String) {
        self.defaultValue = defaultValue
        self.key = key

        keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "warehouse")
            .synchronizable(true)
            .accessibility(.always)
    }

    private func save(_ newValue: Value) {
        guard let data = try? encoder.encode(newValue) else {
            return
        }

        try? keychain.set(data, key: key)
    }

    private func fetch() -> Value {
        guard
            let data = try? keychain.getData(key),
            let freshValue = try? decoder.decode(Value.self, from: data)
        else {
            return defaultValue
        }

        return freshValue
    }
}
