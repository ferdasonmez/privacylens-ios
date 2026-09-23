import SwiftUI
import NetworkExtension

@main
struct PrivacyLensIOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var status = "Checking Network Extension..."

    var body: some View {
        VStack(spacing: 16) {
            Text("PrivacyLens iOS")
                .font(.largeTitle).bold()
            Text("Architecture proof")
                .foregroundStyle(.secondary)
            Text("Container app + PrivacyLensTunnel\n(NEPacketTunnelProvider)")
                .multilineTextAlignment(.center)
            Divider()
            Text("Network Extension probe:")
                .font(.headline)
            Text(status)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .task { await probeTunnel() }
    }

    /// Tries to save a VPN configuration pointing at the PrivacyLensTunnel extension
    /// and start it. The result (success or the exact error) is shown on screen,
    /// so the simulator screenshot answers "does the tunnel start here?".
    private func probeTunnel() async {
        do {
            let managers = try await NETunnelProviderManager.loadAllFromPreferences()
            let manager = managers.first ?? NETunnelProviderManager()
            let proto = NETunnelProviderProtocol()
            proto.providerBundleIdentifier = "com.thecyberlayer.PrivacyLensIOS.PrivacyLensTunnel"
            proto.serverAddress = "127.0.0.1"
            manager.protocolConfiguration = proto
            manager.localizedDescription = "PrivacyLens"
            manager.isEnabled = true
            try await manager.saveToPreferences()
            status = "VPN configuration saved."
            try manager.connection.startVPNTunnel()
            status += "\nstartVPNTunnel() called."
        } catch {
            status = "Result: \(error.localizedDescription)"
        }
        print("PRIVACYLENS_PROBE: \(status)")
    }
}
