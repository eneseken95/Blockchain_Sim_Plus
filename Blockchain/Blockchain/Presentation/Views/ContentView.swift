//
//  ContentView.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 1.11.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = SimulatorViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Picker("Mode", selection: $vm.mode) {
                            ForEach(Mode.allCases, id: \.self) { m in
                                Text(m.rawValue).tag(m)
                            }
                        }
                        .pickerStyle(.segmented)
                        .tint(.accentColor)
                    }
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 4)

                    paramsSection

                    Button {
                        Task { await vm.run() }
                    } label: {
                        Text(vm.isRunning ? "Running…" : "Run Simulation")
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 15)
                            .padding()
                            .background(vm.isRunning ? Color.gray : Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(vm.isRunning)

                    if vm.isRunning {
                        VStack(alignment: .leading, spacing: 8) {
                            ProgressView(value: vm.progress)
                                .progressViewStyle(.linear)

                            HStack {
                                Text("Progress: \(vm.progressLabel)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Button("Cancel") { vm.cancelRequested = true }
                                    .font(.caption)
                                    .foregroundStyle(.pink)
                            }

                            ForEach(vm.stepLogs, id: \.self) { s in
                                Text("• \(s)").font(.caption).foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(vm.metrics.sorted(by: { $0.key < $1.key }), id: \.key) { k, v in
                                MetricCard(title: k, value: v)
                            }
                        }
                    }

                    if !vm.samples.isEmpty {
                        ChartsView(samples: vm.samples)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(vm.logs.suffix(200).enumerated()), id: \.offset) { _, line in
                            Text(line)
                                .font(.footnote)
                                .monospaced()
                                .foregroundColor(Color.green)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image("Blockchain")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
                            )
                        (
                            Text("Blockchain ").foregroundColor(.white) +
                                Text("Sim+").foregroundColor(.green)
                        )
                        .font(.title)
                        .fontWeight(.bold)

                        Spacer()
                    }
                }
            }
        }
    }

    @ViewBuilder var paramsSection: some View {
        switch vm.mode {
        case .pow:
            VStack(alignment: .leading) {
                Stepper("Difficulty: \(vm.difficulty)", value: $vm.difficulty, in: 1 ... 7)
                Stepper("Blocks: \(vm.blocks)", value: $vm.blocks, in: 1 ... 30)
                Toggle("Fork Simulation", isOn: $vm.enableForkSim)
                if vm.enableForkSim {
                    Stepper("Fork Miners: \(vm.forkMiners)", value: $vm.forkMiners, in: 1 ... 6)
                    Stepper("Fork Rounds: \(vm.forkRounds)", value: $vm.forkRounds, in: 1 ... 30)
                    HStack {
                        Text("Fork Prob: \(Int(vm.forkProb * 100))%")
                        Slider(value: $vm.forkProb, in: 0 ... 0.9)
                    }
                }
            }
        case .pos:
            VStack(alignment: .leading) {
                Stepper("Validators: \(vm.validators)", value: $vm.validators, in: 1 ... 20)
                Stepper("Epochs: \(vm.epochs)", value: $vm.epochs, in: 1 ... 10)
                Stepper("Slots/Epoch: \(vm.slotsPerEpoch)", value: $vm.slotsPerEpoch, in: 1 ... 50)
                HStack {
                    Text("Offline: \(Int(vm.offlineProb * 100))%")
                    Slider(value: $vm.offlineProb, in: 0 ... 0.6)
                }
                HStack {
                    Text("Equivocation: \(Int(vm.equivProb * 100))%")
                    Slider(value: $vm.equivProb, in: 0 ... 0.3)
                }
                Stepper("Slash: \(vm.slash)", value: $vm.slash, in: 1 ... 5)
            }
        }
    }
}

#Preview {
    ContentView()
}
