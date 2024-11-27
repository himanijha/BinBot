//
//  HomeTabsView.swift
//  BinBot
//
//  Created by Himani Jha on 11/22/24.
//
import SwiftUI
struct HomeTabsView: View {
    struct Bin: Hashable, Identifiable {
        let name: String
        let text: String
        var id: String {
            name
        }
    }
    
    static let trashBin = Bin(name: "Trash", text: "Trash text")
    static let recyclingBin = Bin(name: "Recycling", text:
    """
    • Check for recycling symbols on the item
    • Look for material type - plastic, paper, glass, metal
    • Ensure the item is clean and free from food residue
    • When in doubt, check your local recycling guidelines
    """)
    static let compostBin = Bin(name: "Compost", text: "Compost text")
    static let bins = [trashBin, recyclingBin, compostBin]
    
    @State private var binType = trashBin
    
    var body: some View {
        VStack {
            Picker("What is your favorite bin?", selection: $binType) {
                ForEach(Self.bins) {
                    Text($0.name).tag($0)
                }
            }
            .pickerStyle(.segmented)
            
            TabView(selection: $binType) {
                ForEach(Self.bins) {
                    Text($0.text).tag($0)
                }
            }
            .tabViewStyle(.page)
        }
    }
}
#Preview {
    HomeTabsView()
}
