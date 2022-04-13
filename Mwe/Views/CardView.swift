//
//  CardView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/12/22.
//

import SwiftUI

struct ImageCardView: View {
    @Binding var showingAddScreen: Bool
    @EnvironmentObject var deck: CardDeck
    let card: Card
    var body: some View {
        VStack {
            if let imageUrl = card.imageUrl, card.type == .Image {
                SquareImage(url: imageUrl)                    .shadow(radius: 3)
            } else if (card.type == .Placeholder){
                VStack(alignment: .center) {
                    GeometryReader { gr in
                        VStack(alignment: .center) {
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding()
                            Text("Add your painting")
                                .bold()
                        }
                        .foregroundColor(.accentColor)
                        .frame(
                            width: gr.size.width,
                            height: gr.size.width)
                    }
                }
                .onTapGesture {
                    self.showingAddScreen = true
                }
                .padding()
                .background(.white)
                .clipped()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(5)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0,
                        coordinateSpace: .local)
                .onEnded({ value in
                    let horizTranslation = value.translation.width
                    if horizTranslation != 0 {
                        deck.select(card)
                    }
                }
            )
        )
    }
}

struct ImageCardStackView: View {
    @EnvironmentObject var user: User
    @Binding var post: Post
    @Binding var painting: UIImage?
    @Binding var showingAddScreen: Bool
    @StateObject var deck: CardDeck = CardDeck()
    
    let stepSize = 5.0
    
    func getCards() -> [Card]{
        var cards: [Card] = []
        if let paintingUrl: String = post.paintingUrl {
            cards.append(Card(type: .Image, imageUrl: paintingUrl))
        } else if (post.createdBy == user.id){
            cards.append(Card(type: .Placeholder, imageUrl: nil))
        }
        cards.append(Card(type: .Image, imageUrl: post.photographUrl))
        return cards
    }
    
    func getInitialOffSet() -> Double {
        return -stepSize * Double(self.deck.cards.count - 1)
    }
    
    var body: some View {
        ZStack {
            ForEach(deck.cards){ card in
                ImageCardView(showingAddScreen: $showingAddScreen,
                              card: card)
                    .zIndex(1.0 * self.deck.indexOfCard(card))
                    .offset(
                        x: getInitialOffSet() + stepSize * 2 * self.deck.indexOfCard(card),
                        y: getInitialOffSet() + stepSize * 2 * self.deck.indexOfCard(card)
                    )
                    .shadow(radius: 3)
                    .scaledToFill()
                    .environmentObject(deck)
            }
        }.onAppear(perform: {
            self.deck.cards = getCards()
        }).onChange(of: post, perform: { _ in
            self.deck.cards = getCards()
        })
        .padding([.top], stepSize * 1.5)
    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardStackView(
            post: .constant(Post.example),
            painting:.constant(nil),
            showingAddScreen: .constant(true)
        )
            .environmentObject(User())
    }
}

