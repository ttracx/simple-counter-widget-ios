import SwiftUI
import WidgetKit

class CounterViewModel: ObservableObject {
    @Published var count: Int
    @Published var counterName: String
    @Published var isPro = false
    
    private let defaults = UserDefaults(suiteName: "group.com.yourname.simplecounterwidget")
    private let countKey = "counterValue"
    private let nameKey = "counterName"
    private let proKey = "isProUser"
    
    init() {
        count = defaults?.integer(forKey: countKey) ?? 0
        counterName = defaults?.string(forKey: nameKey) ?? "Count"
        isPro = defaults?.bool(forKey: proKey) ?? false
    }
    
    func increment() {
        count += 1
        save()
    }
    
    func decrement() {
        count = max(0, count - 1)
        save()
    }
    
    func reset() {
        count = 0
        save()
    }
    
    private func save() {
        defaults?.set(count, forKey: countKey)
        defaults?.set(counterName, forKey: nameKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func purchasePro() {
        isPro = true
        defaults?.set(true, forKey: proKey)
    }
}
