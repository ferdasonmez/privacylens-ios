import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
        let dnsSettings = NEDNSSettings(servers: ["127.0.0.1"])
        dnsSettings.matchDomains = [""]
        settings.dnsSettings = dnsSettings

        setTunnelNetworkSettings(settings) { error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.startReadingPackets()
            completionHandler(nil)
        }
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    private func startReadingPackets() {
        packetFlow.readPackets { [weak self] packets, protocols in
            for packet in packets {
                self?.inspectPacket(packet)
            }
            self?.startReadingPackets()
        }
    }

    private func inspectPacket(_ packet: Data) {
        guard let domain = DomainExtractor.extractDomain(from: packet) else { return }
        let classification = TrackerClassifier.classify(domain: domain)
        EventLogger.shared.log(domain: domain, classification: classification)
    }
}
