//
//  CategoryListView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    private let columns = Array(repeating: GridItem(.fixed(DeviceSizeUtility.deviceWidth / 2 - 20)), count: 2)
    
    @State private var showSearchView = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(rootEnvironment.categorys) { category in
                            NavigationLink {
                                DetailCategoryView(category: category)
                                    .environmentObject(rootEnvironment)
                            } label: {
                                VStack {
                                    Text(category.name)
                                        .frame(width: DeviceSizeUtility.deviceWidth / 2 - 20, height: 80)
                                        .font(.system(size: 20, weight: .bold))
                                        .background(.themaBlack)
                                        .foregroundStyle(.white)
                                        .cornerRadius(8)
                                    
                                    
                                }
                               
                            }
                        }
                    }
                    Spacer()
                }
                
                Button {
                    showSearchView = true
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 40, height: 40)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .background(.themaBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .overlay {
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(.white)
                                
                        }.shadow(color: .gray, radius: 1, x: 1, y: 1)
                }.alignmentGuide(.trailing) { _ in 80 }
                    .alignmentGuide(.bottom) { _ in 80 }
            }
        }.sheet(isPresented: $showSearchView) {
            InputCategoryView()
                .environmentObject(rootEnvironment)
        }
    }
}

#Preview {
    CategoryListView()
}
