//
//  SharedComponents.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/11/26.
//

import SwiftUI

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
