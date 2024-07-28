//
//  PlanMenuView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/10.
//

import SwiftUI

struct PlanMenuView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPlacePicker = false
    @State var showDatePicker = false
    @State private var showRidePicker = false
    @State private var selectedPlace = ""
    @State private var selectedRide = ""
    @State var selectedDates: Set<DateComponents> = []
    @State private var navigateToPlanView = false
    @State private var indexd = 0
    @State private var planName: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.init(hex: "5E845B", alpha: 1.0)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.white)
                                .font(.system(size: 30))
                        }
                        Spacer()
                    }.padding()
                    
                    Spacer()
                        .frame(height: 100)
         
                    VStack(alignment: .leading) {
                        
                        Text("行程名稱")
                            .bold()
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                        
                        TextField("", text: $planName)
                            .padding(.horizontal)
                            .frame(width: 330, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        
                        
                        
                        HStack {
                            Text("目的地")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            Spacer()
                                .frame(width: 150)
                        }
                        Button(action: {
                            showPlacePicker.toggle()
                        }, label: {
                            HStack {
                                Text(selectedPlace.isEmpty ? "" : selectedPlace)
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .padding()
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                                    .bold()
                                    .font(.system(size: 25))
                                    .padding()
                            }
                            .frame(width: 330, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        })
                        
                        HStack {
                            Text("行程日期")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            Spacer()
                                .frame(width: 150)
                        }
                        Button(action: {
                            showDatePicker.toggle()
                        }, label: {
                            HStack {
                                Text(formatSelectedDates(selectedDates))
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .padding()
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                                    .bold()
                                    .font(.system(size: 25))
                                    .padding()
                            }
                            .frame(width: 330, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        })
                        
                        HStack {
                            Text("主要交通方式")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            Spacer()
                                .frame(width: 150)
                        }
                        Button(action: {
                            showRidePicker.toggle()
                        }, label: {
                            HStack {
                                Text(selectedRide.isEmpty ? "" : selectedRide)
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .padding()
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                                    .bold()
                                    .font(.system(size: 25))
                                    .padding()
                            }
                            .frame(width: 330, height: 36)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.bottom)
                        })
                    }
                    
                    Spacer()
                        .frame(height: 75)
                    
                    NavigationLink(destination: PlanView(indexd: $indexd)) {
                        Text("確定")
                            .bold()
                            .font(.system(size: 25))
                            .foregroundColor(Color(hex: "5E845B", alpha: 1.0))
                    }
                    .frame(width: 100, height: 42)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showPlacePicker) {
                PlacePicker(selectedPlace: $selectedPlace)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showDatePicker) {
                DatePick(selectedDates: $selectedDates)
                    .presentationDetents([.height(435)])
            }
            .sheet(isPresented: $showRidePicker) {
                RidePicker(selectedRide: $selectedRide)
                    .presentationDetents([.medium])
            }
        }
    }
    
    // Helper function to format selected dates
    private func formatSelectedDates(_ dates: Set<DateComponents>) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd" // Alternative custom format
        
        let datesArray = dates.compactMap { Calendar.current.date(from: $0) }
        let sortedDates = datesArray.sorted()
        
        if let firstDate = sortedDates.first, let lastDate = sortedDates.last, firstDate != lastDate {
            return "\(dateFormatter.string(from: firstDate)) - \(dateFormatter.string(from: lastDate))"
        } else if let singleDate = sortedDates.first {
            return dateFormatter.string(from: singleDate)
        } else {
            return ""
        }
    }
}

struct PlanMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PlanMenuView()
    }
}
