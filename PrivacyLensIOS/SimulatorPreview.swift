import SwiftUI

#if targetEnvironment(simulator)

/// Simulator-only preview: the simulator has no VPN service, so instead of the
/// tunnel probe this shows the app's screens filled with clearly fake sample data.
/// None of this code is compiled into a build for a real iPhone.

struct SampleApp: Identifiable {
    let id = UUID()
    let name: String
    let trackerContacts: Int
    let companies: [String]
}

struct SampleCompany: Identifiable {
    let id = UUID()
    let name: String
    let domains: [String]
    let contacts: Int
}

struct SampleEvent: Identifiable {
    let id = UUID()
    let time: String
    let app: String
    let domain: String
    let company: String
}

enum SampleData {
    static let apps = [
        SampleApp(name: "Example Weather App", trackerContacts: 42,
                  companies: ["Example Ads Ltd", "Sample Analytics Co"]),
        SampleApp(name: "Sample Shopping App", trackerContacts: 27,
                  companies: ["Example Ads Ltd", "Demo Metrics Inc", "Test Profiling Ltd"]),
        SampleApp(name: "Demo News App", trackerContacts: 15,
                  companies: ["Sample Analytics Co"]),
        SampleApp(name: "Test Fitness App", trackerContacts: 8,
                  companies: ["Demo Metrics Inc"]),
    ]

    static let companies = [
        SampleCompany(name: "Example Ads Ltd",
                      domains: ["ads.example.com", "pixel.example.com"], contacts: 39),
        SampleCompany(name: "Sample Analytics Co",
                      domains: ["stats.example.net"], contacts: 31),
        SampleCompany(name: "Demo Metrics Inc",
                      domains: ["metrics.example.org"], contacts: 14),
        SampleCompany(name: "Test Profiling Ltd",
                      domains: ["id.example.com"], contacts: 8),
    ]

    static let timeline = [
        SampleEvent(time: "09:41", app: "Example Weather App",
                    domain: "ads.example.com", company: "Example Ads Ltd"),
        SampleEvent(time: "09:40", app: "Sample Shopping App",
                    domain: "id.example.com", company: "Test Profiling Ltd"),
        SampleEvent(time: "09:38", app: "Demo News App",
                    domain: "stats.example.net", company: "Sample Analytics Co"),
        SampleEvent(time: "09:35", app: "Test Fitness App",
                    domain: "metrics.example.org", company: "Demo Metrics Inc"),
        SampleEvent(time: "09:31", app: "Example Weather App",
                    domain: "pixel.example.com", company: "Example Ads Ltd"),
    ]
}

struct SimulatorPreviewView: View {
    /// Starting tab; CI sets it with a launch argument (-previewTab 1) to screenshot each tab.
    @AppStorage("previewTab") private var tab = 0

    var body: some View {
        VStack(spacing: 0) {
            Text("Simulator preview, sample data")
                .font(.subheadline).bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.orange)
            TabView(selection: $tab) {
                AppsPreview()
                    .tabItem { Label("Apps", systemImage: "square.grid.2x2") }
                    .tag(0)
                TimelinePreview()
                    .tabItem { Label("Timeline", systemImage: "clock") }
                    .tag(1)
                CompaniesPreview()
                    .tabItem { Label("Companies", systemImage: "building.2") }
                    .tag(2)
            }
        }
    }
}

struct AppsPreview: View {
    var body: some View {
        NavigationStack {
            List(SampleData.apps) { app in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(app.name).font(.headline)
                        Spacer()
                        Text("\(app.trackerContacts)").bold()
                    }
                    Text(app.companies.joined(separator: ", "))
                        .font(.caption).foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Apps")
        }
    }
}

struct TimelinePreview: View {
    var body: some View {
        NavigationStack {
            List(SampleData.timeline) { event in
                HStack(alignment: .top, spacing: 12) {
                    Text(event.time).font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.app).font(.subheadline).bold()
                        Text(event.domain).font(.caption.monospaced())
                        Text(event.company).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Timeline")
        }
    }
}

struct CompaniesPreview: View {
    var body: some View {
        NavigationStack {
            List(SampleData.companies) { company in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(company.name).font(.headline)
                        Spacer()
                        Text("\(company.contacts)").bold()
                    }
                    Text(company.domains.joined(separator: ", "))
                        .font(.caption.monospaced()).foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Companies")
        }
    }
}

#endif
