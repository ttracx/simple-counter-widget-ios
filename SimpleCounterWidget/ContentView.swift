import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CounterViewModel()
    @State private var showingPaywall = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Large Counter Display
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 200, height: 200)
                    
                    VStack {
                        Text("\(viewModel.count)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                        
                        Text(viewModel.counterName)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
                
                // Controls
                HStack(spacing: 40) {
                    Button(action: { viewModel.decrement() }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                    }
                    
                    Button(action: { viewModel.increment() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                    }
                }
                
                // Settings
                List {
                    Section("Counter Settings") {
                        TextField("Counter Name", text: $viewModel.counterName)
                        
                        Button("Reset to 0") {
                            viewModel.reset()
                        }
                        .foregroundColor(.red)
                    }
                    
                    Section {
                        Button(action: { showingPaywall = true }) {
                            HStack {
                                Image(systemName: viewModel.isPro ? "checkmark.circle.fill" : "crown.fill")
                                Text(viewModel.isPro ? "Pro Active" : "Unlock Multiple Counters - $0.99")
                            }
                            .foregroundColor(viewModel.isPro ? .green : .orange)
                        }
                        .disabled(viewModel.isPro)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Simple Counter")
            .sheet(isPresented: $showingPaywall) {
                PaywallView(viewModel: viewModel)
            }
        }
    }
}

struct PaywallView: View {
    @ObservedObject var viewModel: CounterViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "number.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Counter Pro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack { Image(systemName: "plus.square.stack").foregroundColor(.blue); Text("Unlimited counters") }
                    HStack { Image(systemName: "paintpalette").foregroundColor(.blue); Text("Custom colors") }
                    HStack { Image(systemName: "chart.bar").foregroundColor(.blue); Text("Statistics & history") }
                    HStack { Image(systemName: "arrow.uturn.backward").foregroundColor(.blue); Text("Undo last change") }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Text("$0.99")
                        .font(.system(size: 48, weight: .bold))
                    
                    Text("One-time purchase")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    viewModel.purchasePro()
                    dismiss()
                }) {
                    Text("Purchase Pro")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarItems(trailing: Button("Close") { dismiss() })
        }
    }
}
