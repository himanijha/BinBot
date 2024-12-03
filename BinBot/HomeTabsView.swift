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
        let iconName: String
        var id: String {
            name
        }
    }
    
    static let trashBin = Bin(name: "Trash", text: """
      Items that cannot be recycled or composted
      Food wrappers, broken glass, and plastic bags
      Styrofoam containers and packaging
      Non-recyclable paper (e.g., greasy pizza boxes)
      Any item that is not clean or dry
    """, iconName: "trash.fill")
    
    static let recyclingBin = Bin(name: "Recycling", text: """
      Check for recycling symbols on the item
      Look for material type - plastic, paper, glass, metal
      Ensure the item is clean and free from food residue
      When in doubt, check your local recycling guidelines
    """, iconName: "arrow.triangle.2.circlepath.circle.fill")

    static let compostBin = Bin(name: "Compost", text: """
      Fruit and vegetable scraps
      Coffee grounds, tea bags, and eggshells
      Yard waste, such as grass clippings and leaves
      Non-glossy paper towels and napkins
      Avoid meat, dairy, and oily foods
    """, iconName: "leaf.fill")
    
    static let bins = [trashBin, recyclingBin, compostBin]
    
    @State private var binType = trashBin
    
    var body: some View {
        VStack {
            Picker("What is your favorite bin?", selection: $binType) {
                ForEach(Self.bins) { bin in
                    HStack {
                        //Image(systemName: bin.iconName)
                            //.font(.title)
                        Text(bin.name)
                    }
                    .tag(bin)
                }
            }
            .pickerStyle(.segmented)
            // .padding()

            TabView(selection: $binType) {
                ForEach(Self.bins) { bin in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            let bulletPoints = bin.text.split(separator: "\n")
                            ForEach(bulletPoints, id: \.self) { point in
                                HStack {
                                    Text("•")
                                        .font(.body)
                                    Text(point)
                                        .font(.body)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                    }
                    .tag(bin)
                    .tabItem {
                        //Image(systemName: bin.iconName)
                        Text(bin.name)
                    }
                }
            }
            .tabViewStyle(.page)
        }
        .padding()
    }
}

#Preview {
    HomeTabsView()
}
