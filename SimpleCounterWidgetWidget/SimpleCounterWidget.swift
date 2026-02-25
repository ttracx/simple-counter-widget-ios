import WidgetKit
import SwiftUI

struct CounterProvider: TimelineProvider {
    func placeholder(in context: Context) -> CounterEntry {
        CounterEntry(date: Date(), count: 42, name: "Count")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CounterEntry) -> ()) {
        let (count, name) = loadCounter()
        let entry = CounterEntry(date: Date(), count: count, name: name)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let (count, name) = loadCounter()
        let currentDate = Date()
        
        var entries: [CounterEntry] = []
        for minuteOffset in stride(from: 0, to: 60, by: 5) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            entries.append(CounterEntry(date: entryDate, count: count, name: name))
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func loadCounter() -> (Int, String) {
        let defaults = UserDefaults(suiteName: "group.com.yourname.simplecounterwidget")
        let count = defaults?.integer(forKey: "counterValue") ?? 0
        let name = defaults?.string(forKey: "counterName") ?? "Count"
        return (count, name)
    }
}

struct CounterEntry: TimelineEntry {
    let date: Date
    let count: Int
    let name: String
}

struct SimpleCounterWidgetEntryView : View {
    var entry: CounterProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color.blue.gradient)
            
            VStack(spacing: 4) {
                Text(entry.name)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(entry.count)")
                    .font(.system(size: family == .systemSmall ? 40 : 56, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                if family != .systemSmall {
                    Text("tap + or - in app")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding()
        }
    }
}

@main
struct SimpleCounterWidget: Widget {
    let kind: String = "SimpleCounterWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CounterProvider()) { entry in
            SimpleCounterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Simple Counter")
        .description("Track anything with a tap counter")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
