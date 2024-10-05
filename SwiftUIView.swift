//
//  MapView.swift
//  StoryGraph-v1
//
//  Created by Foster Docherty on 9/28/24.
//

import SwiftUI

struct nodeMetadata {
    var title: String
    var imageName: String
    var imageOverlayOpacity: CGFloat?
}

let titlesAndNames: [nodeMetadata] = [
    nodeMetadata(title: "Why Study Mathematics?", imageName: "Node0001"),
    nodeMetadata(title: "Propositional Logic", imageName: "Node0002"),
    nodeMetadata(title: "Variables & Negation", imageName: "Node0003"),
    nodeMetadata(title: "Truth Tables", imageName: "Node0004", imageOverlayOpacity: 0.1),
    nodeMetadata(title: "Connectives: Part 1", imageName: "Node0005"),
    nodeMetadata(title: "Connectives: Part 2", imageName: "Node0006"),
    nodeMetadata(title: "Predicates & Quantifiers", imageName: "Node0007"),
    nodeMetadata(title: "Intro to Sets", imageName: "Node0008"),
    nodeMetadata(title: "ZFC Set Axioms", imageName: "Node0009"),
    nodeMetadata(title: "Extensionality (ZFC.1)", imageName: "Node0010"),
    nodeMetadata(title: "Unrestricted Comprehension", imageName: "Node0011"),
    nodeMetadata(title: "Separation (ZFC.2) & Subset", imageName: "Node0012"),
    nodeMetadata(title: "Pairing (ZFC.3) & Singleton", imageName: "Node0013"),
    nodeMetadata(title: "Union (ZFC.4) & Intersection", imageName: "Node0014"),
    nodeMetadata(title: "Replacement (ZFC.5) & Function", imageName: "Node0015"),
    nodeMetadata(title: "Infinity (ZFC.6) & Omega", imageName: "Node0016"),
    nodeMetadata(title: "Power Set (ZFC.7)", imageName: "Node0017"),
    nodeMetadata(title: "Foundation (ZFC.8)", imageName: "Node0018"),
    nodeMetadata(title: "Choice (ZFC.9)", imageName: "Node0019"),
    ]

struct MapView : View {
    @EnvironmentObject var base: Base
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                ForEach(0..<titlesAndNames.count, id: \.self) { index in
                    if let imageOverlayOpacity = titlesAndNames[index].imageOverlayOpacity {
                        MapNode(title: titlesAndNames[index].title, imageName: titlesAndNames[index].imageName, imageOverlayOpacity: imageOverlayOpacity)
                            .onTapGesture {
                                withAnimation {
                                    base.currentNode = index + 1 // Since nodes start at Node0001 (1-indexed)
                                }
                            }
                    } else {
                        MapNode(title: titlesAndNames[index].title, imageName: titlesAndNames[index].imageName)
                            .onTapGesture {
                                withAnimation {
                                    base.currentNode = index + 1 // Since nodes start at Node0001 (1-indexed)
                                }
                            }
                    }
                }
            }
        }
        .padding(.top, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Aligns content to the top, instead of center
        .background(Color.white)
    }
}

struct MapNode : View {
    @EnvironmentObject var base: Base
    
    var title: String
    var imageName: String
    
    var imageOverlayOpacity: CGFloat = 0
    var imageHeight: CGFloat = 250
    var imageCornerRadius: CGFloat = 0
    var imageBottomPadding: CGFloat = 0
    
    //var textLeadingPadding: CGFloat = 40 // or use base.contentSidePadding
    var textTrailingPadding: CGFloat = 80 // or use base.contentSidePadding
    var textShadowRadius: CGFloat = 8
    var textShadowX: CGFloat = 3
    var textShadowY: CGFloat = 2
    
    var body: some View {
        ZStack{
            Image(imageName)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: imageHeight)
                .overlay(
                    Color.black.opacity(imageOverlayOpacity)  // Darken the image with a semi-transparent black overlay
                )
                .mask(RoundedRectangle(cornerRadius: imageCornerRadius))
                .padding(.bottom, imageBottomPadding)
                .clipped()
            VStack{
                Spacer()
                Text("")
                    .font(.title)
                Spacer()
                Text("")
                    .font(.title)
                Spacer()
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, base.contentSidePadding)
                    .padding(.trailing, textTrailingPadding)
                    .shadow(color: Color.black, radius: textShadowRadius, x: textShadowX, y: textShadowY)
                Spacer()
            }
        }
    }
}

#Preview {
    MapView().environmentObject(Base())
}
