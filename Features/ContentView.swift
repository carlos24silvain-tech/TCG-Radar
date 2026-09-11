import SwiftUI

struct ContentView: View {
    @State private var huntMode = true
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView(huntMode: $huntMode)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            DropsView()
                .tabItem {
                    Label("Drops", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(1)

            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }
                .tag(2)

            CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "square.stack.3d.up.fill")
                }
                .tag(3)

            AnalyticsView()
                .tabItem {
                    Label("AI", systemImage: "brain.head.profile")
                }
                .tag(4)
        }
        .tint(.orange)
    }
}

// MARK: - Home

struct HomeView: View {
    @Binding var huntMode: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TCG RADAR")
                                .font(.largeTitle.bold())

                            Text("Your collection. Your edge.")
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 30))
                            .foregroundStyle(.orange)
                    }

                    HStack {
                        Image(systemName: "scope")
                            .foregroundStyle(.orange)

                        VStack(alignment: .leading) {
                            Text("Hunt Mode")
                                .font(.headline)

                            Text("Find opportunities automatically")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Toggle("", isOn: $huntMode)
                            .labelsHidden()
                    }
                    .padding()
                    .background(.orange.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    HStack(spacing: 12) {
                        MetricCard(
                            title: "Collection",
                            value: "$12,482",
                            icon: "square.stack.3d.up.fill"
                        )

                        MetricCard(
                            title: "Today's Moves",
                            value: "+8.4%",
                            icon: "chart.line.uptrend.xyaxis"
                        )
                    }

                    Text("LIVE DROPS")
                        .font(.headline)

                    OpportunityCard(
                        title: "Pokémon Mega Evolution",
                        subtitle: "Target release detected",
                        value: "HIGH",
                        icon: "bolt.fill"
                    )

                    OpportunityCard(
                        title: "One Piece Booster Box",
                        subtitle: "Price dropped 14%",
                        value: "BUY",
                        icon: "arrow.down.circle.fill"
                    )

                    Text("BIGGEST MOVERS")
                        .font(.headline)

                    HStack {
                        MoverRow(name: "Charizard ex", change: "+18.2%")
                        Spacer()
                        MoverRow(name: "Pikachu", change: "+11.7%")
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Drops

struct DropsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Drop Radar") {
                    DropRow(
                        game: "Pokémon",
                        product: "Mega Evolution",
                        retailer: "Target",
                        status: "WATCH"
                    )

                    DropRow(
                        game: "Magic: The Gathering",
                        product: "Commander Collection",
                        retailer: "Best Buy",
                        status: "SOON"
                    )

                    DropRow(
                        game: "One Piece",
                        product: "Booster Box",
                        retailer: "GameStop",
                        status: "LIVE"
                    )
                }
            }
            .navigationTitle("Drop Radar")
        }
    }
}

struct ScanView: View {

    @EnvironmentObject private var collectionStore: CollectionStore
    
    
    @State private var recognizedText = ""
    @State private var verifiedCard: CardIdentity?
    @State private var isVerifying = false
    @State private var verificationMessage = ""
    
    private var possibleCardName: String {
        let lines = recognizedText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        return lines.first ?? ""
    }
    
    var body: some View {
        ZStack {
            
            CameraScannerView(
                recognizedText: $recognizedText
            )
            .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("TCG RADAR")
                        .font(.headline)
                    
                    if let card = verifiedCard {
                        
                        Text("VERIFIED CARD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        
                        Text(card.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Divider()
                        
                        HStack {
                            Text("Game")
                            Spacer()
                            Text(card.game)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Set")
                            Spacer()
                            Text(card.setName)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Collector #")
                            Spacer()
                            Text(card.collectorNumber)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Language")
                            Spacer()
                            Text(card.language)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Finish")
                            Spacer()
                            Text(card.finish)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Market Value")
                            Spacer()
                            Text(String(format: "$%.2f", card.marketValue))
                                .fontWeight(.bold)
                        }
                        
                        Button("SCAN ANOTHER CARD") {
                            verifiedCard = nil
                            verificationMessage = ""
                        }
                        .buttonStyle(.borderedProminent)
                        
                    } else if possibleCardName.isEmpty {
                        
                        Text("Point your camera at a card...")
                            .foregroundStyle(.secondary)
                        
                    } else {
                        
                        Text("POSSIBLE CARD MATCH")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        
                        Text(possibleCardName)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("OCR detected the card name.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Button {
                            verifyCard()
                        } label: {
                            if isVerifying {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("VERIFY CARD")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isVerifying)
                        
                        if !verificationMessage.isEmpty {
                            Text(verificationMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding()
            }
        }
    }
    
    private func verifyCard() {
        
        guard !possibleCardName.isEmpty else {
            return
        }
        
        isVerifying = true
        verificationMessage = ""
        
        Task {
            do {
                let card = try await ScryfallService.shared.searchCard(
                    named: possibleCardName
                )
                
                await MainActor.run {
                    collectionStore.addCard(card)
                    verifiedCard = card
                    isVerifying = false
                }
                
            } catch {
                
                await MainActor.run {
                    verificationMessage = "Card verification failed. Try scanning again."
                    isVerifying = false
                }
            }
        }
    }
}
// MARK: - Collection
struct CollectionView: View {
    
    @EnvironmentObject private var collectionStore: CollectionStore
    
    var body: some View {
        NavigationStack {
            
            List {
                
                Section {
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("Total Value")
                                .foregroundStyle(.secondary)
                            
                            Text(
                                String(
                                    format: "$%.2f",
                                    collectionStore.totalMarketValue
                                )
                            )
                            .font(.system(size: 34, weight: .bold))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            
                            Text("Cards")
                                .foregroundStyle(.secondary)
                            
                            Text("\(collectionStore.cardCount)")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                
                Section("My Cards") {
                    
                    if collectionStore.cards.isEmpty {
                        
                        VStack(spacing: 10) {
                            
                            Image(systemName: "rectangle.stack")
                                .font(.system(size: 40))
                                .foregroundStyle(.secondary)
                            
                            Text("No cards scanned yet")
                                .font(.headline)
                            
                            Text("Verified cards will appear here automatically.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        
                    } else {
                        
                        ForEach(collectionStore.cards) { entry in
                            
                            NavigationLink {
                                CardDetailsView(entry: entry)
                            } label: {
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    
                                    HStack {
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            
                                            Text(entry.name)
                                                .font(.headline)
                                            
                                            Text(entry.game)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            
                                            Text(
                                                String(
                                                    format: "$%.2f",
                                                    entry.totalValue
                                                )
                                            )
                                            .font(.headline)
                                            
                                            Text("QTY \(entry.totalQuantity)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    
                                    Text(entry.setName)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("#\(entry.collectorNumber)")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                    
                                    ForEach(entry.versions) { version in
                                        
                                        HStack {
                                            
                                            Text(version.finish.capitalized)
                                            
                                            if version.variant != "Standard" {
                                                Text("•")
                                                Text(version.variant)
                                            }
                                            
                                            Text("×\(version.quantity)")
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Text(
                                                String(
                                                    format: "$%.2f",
                                                    version.totalValue
                                                )
                                            )
                                            .foregroundStyle(.secondary)
                                        }
                                        .font(.caption)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Collection")
        }
    }
}
// MARK: - AI Analytics

struct AnalyticsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.largeTitle)
                            .foregroundStyle(.purple)

                        VStack(alignment: .leading) {
                            Text("AI Market Intelligence")
                                .font(.title2.bold())

                            Text("Signals from your market data")
                                .foregroundStyle(.secondary)
                        }
                    }

                    AnalyticsCard(
                        title: "Market Momentum",
                        value: "Bullish",
                        detail: "Trading activity is increasing across tracked cards."
                    )

                    AnalyticsCard(
                        title: "Best Opportunity",
                        value: "Charizard ex",
                        detail: "Strong demand with positive recent movement."
                    )

                    AnalyticsCard(
                        title: "Risk Watch",
                        value: "Low",
                        detail: "Current collection exposure is relatively balanced."
                    )
                }
                .padding()
            }
            .navigationTitle("AI")
        }
    }
}

// MARK: - Reusable Views

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.orange)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct OpportunityCard: View {
    let title: String
    let subtitle: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 45, height: 45)
                .background(.orange.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(value)
                .font(.caption.bold())
                .foregroundStyle(.orange)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct MoverRow: View {
    let name: String
    let change: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.subheadline.bold())

            Text(change)
                .font(.caption)
                .foregroundStyle(.green)
        }
    }
}

struct DropRow: View {
    let game: String
    let product: String
    let retailer: String
    let status: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(game)
                    .font(.caption)
                    .foregroundStyle(.orange)

                Spacer()

                Text(status)
                    .font(.caption.bold())
            }

            Text(product)
                .font(.headline)

            Text(retailer)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

struct CardRow: View {
    let name: String
    let setName: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: "rectangle.portrait.fill")
                .foregroundStyle(.orange)

            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)

                Text(setName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(value)
                .font(.headline)
        }
    }
}

struct AnalyticsCard: View {
    let title: String
    let value: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)

            Text(value)
                .font(.title2.bold())

            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}
// MARK: - Card Details

struct CardDetailsView: View {
    
    let entry: CollectionEntry
    
    var body: some View {
        List {
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(entry.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(entry.game)
                        .foregroundStyle(.secondary)
                    
                    Text(entry.setName)
                        .foregroundStyle(.secondary)
                    
                    Text("#\(entry.collectorNumber)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            
            Section("Collection Summary") {
                
                HStack {
                    Text("Total Quantity")
                    
                    Spacer()
                    
                    Text("\(entry.totalQuantity)")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Total Value")
                    
                    Spacer()
                    
                    Text(
                        String(
                            format: "$%.2f",
                            entry.totalValue
                        )
                    )
                    .fontWeight(.semibold)
                }
            }
            
            
            Section("Versions Owned") {
                
                ForEach(entry.versions) { version in
                    
                    NavigationLink(
                        destination: CardCopiesView(version: version)
                    ) {
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text(version.finish.capitalized)
                                    .font(.headline)
                                
                                if version.variant != "Standard" {
                                    Text(version.variant)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Text(version.language.uppercased())
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                
                                Text("×\(version.quantity)")
                                    .fontWeight(.semibold)
                                
                                Text(
                                    String(
                                        format: "$%.2f",
                                        version.totalValue
                                    )
                                )
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Card Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
