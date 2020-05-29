//
//  PaperView.swift
//  Papers
//
//  Created by Sascha Sallès on 23/05/2020.
//  Copyright © 2020 saschasalles. All rights reserved.
//

import SwiftUI

struct PaperView: View {
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    @EnvironmentObject var papers: PapersViewModel
    var passedPaper: Paper
    @State var presentEditView = false
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    if self.passedPaper.category != nil {
                        BadgeView(color: self.passedPaper.category!.color, text: self.passedPaper.category!.name, logo: self.passedPaper.category!.logo)
                    }
                    Spacer()
                    Text("Expire le \(self.passedPaper.expirationDate, formatter: Self.taskDateFormat)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                HStack(spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            Image(uiImage: self.passedPaper.rectoImage)
                                .resizable()
                                .aspectRatio(self.passedPaper.rectoImage.size, contentMode: .fill)
                                .frame(width: 300, height: 230)
                                .cornerRadius(15)
                            
                            
                            Image(uiImage: self.passedPaper.versoImage)
                                .resizable()
                                .aspectRatio(self.passedPaper.versoImage.size, contentMode: .fill)
                                .frame(width: 300, height: 230)
                                .cornerRadius(15)
                        }.padding([.trailing, .leading])
                    }
                    .frame(height: 240)
                    .shadow(radius: 10)
                }
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Nom")
                            .font(Font.custom("Avenir-black", size: 23))
                            .bold()
                        Text("\(self.passedPaper.name)")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("Description")
                            .font(Font.custom("Avenir-black", size: 23))
                            .bold()
                        Text("\(self.passedPaper.userDescription)")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Date d'ajout")
                            .font(Font.custom("Avenir-black", size: 23))
                            .bold()
                        
                        Text("Ajouté le \(self.passedPaper.addDate, formatter: Self.taskDateFormat)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
                Spacer()
                Button(action: {
                    guard let recordId = self.passedPaper.recordId else { return }
                    CloudKitHelper.deletePaper(recordID: recordId) { (result) in
                        switch result {
                        case .success(let recordID):
                            self.papers.papers.removeAll { (paper) -> Bool in
                                return paper.recordId == recordID
                            }
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                    }
                }){
                    HStack{
                        Image(systemName: "trash")
                        Text("Supprimer")
                    }
                    .frame(height: 20)
                    .padding()
                    .foregroundColor(.red)
                }.cornerRadius(30)
            }
        }
        .navigationBarTitle(Text(self.passedPaper.name), displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: EditPaperView(paper: self.passedPaper), label:{
            Text("Modifier")
        }))
    }
}



//
//struct PaperView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaperView(passedPaper: Paper(name: "test", userDescription: "test", rectoImage: UIImage(named: "recto")!, versoImage: UIImage(named: "verso")!, expirationDate: Date(), addDate: Date()))
//    }
//}
