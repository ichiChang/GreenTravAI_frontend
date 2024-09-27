import SwiftUI
struct JourneyPicker: View {
    @State private var textInput = ""
    @State private var selectedPlanId: String?
    @State private var selectedDate: String?
    @State private var showingDateSelector = false
    @EnvironmentObject var viewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showJPicker: Bool

    var body: some View {
        NavigationStack {
            Button(action: {
                showJPicker = false
            }, label: {
                HStack{
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(hex: "8F785C", alpha: 1.0))
                    Spacer()
                }
                .frame(width: 280)
            })
            .padding()

            Text(showingDateSelector ? "請選擇日期" : "請選擇旅行計劃")
                .font(.system(size: 20))

            if showingDateSelector, let plan = viewModel.travelPlans.first(where: { $0.id == selectedPlanId }) {
                ScrollView {
                    VStack(spacing: 10) {
                        let dates = datesBetween(startDate: plan.startdate, endDate: plan.enddate)
                        ForEach(Array(dates.enumerated()), id: \.element) { index, date in
                            DateRowView(date: date, index: index, totalCount: dates.count, selectedDate: $selectedDate)
                        }
                    }
                }
            } else {
                // Travel plans list
                ScrollView {
                    VStack(spacing: 0) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else if let error = viewModel.error {
                            Text("Error: \(error)")
                        } else if viewModel.travelPlans.isEmpty {
                            Text("No travel plans found")
                        } else {
                            ForEach(viewModel.travelPlans) { plan in
                                Button(action: {
                                    selectedPlanId = plan.id
                                    viewModel.selectedTravelPlan = plan
                                }) {
                                    PlanRowView2(plan: plan, selectedPlanId: $selectedPlanId)
                                }
                            }
                        }
                    }
                }
            }

            // Confirm button
            Button(action: {
                if showingDateSelector && selectedDate != nil {
                    showJPicker = false // Close the picker view if a date has been selected
                } else {
                    showingDateSelector = true // Show date selection
                }
            }) {
                Text(showingDateSelector && selectedDate != nil ? "完成" : "確認")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 40)
                    .background(Color(hex: "8F785C", alpha: 1.0))
                    .cornerRadius(15)
            }
            .padding()
           
        }
        .onAppear {
            if let token = authViewModel.accessToken {
                viewModel.fetchTravelPlans(token: token)
            }
        }
    }

    private func datesBetween(startDate: String, endDate: String) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let start = formatter.date(from: startDate),
              let end = formatter.date(from: endDate) else { return [] }
        
        var dates = [formatter.string(from: start)]
        var currentDate = start
        
        while currentDate < end {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            dates.append(formatter.string(from: currentDate))
        }
        
        return dates
    }
}

struct DateRowView: View {
    let date: String
   let index: Int // Add an index to know the position
   let totalCount: Int // Total count of dates
   @Binding var selectedDate: String?
    
    var body: some View {
        HStack {
            Text(date)
                .bold()
                .padding()
            Spacer()
            Image(systemName: selectedDate == date ? "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(selectedDate == date ? Color(hex: "8F785C", alpha: 1.0) : .gray)
          
        }
        .frame(width: 280)
        .padding(.top,10)
        .onTapGesture {
            self.selectedDate = date
        }
        if index < totalCount - 1 {
            Divider()
                .frame(width: 280)
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
 
        }

    }
}


struct PlanRowView2: View {
    let plan: TravelPlan
    @Binding var selectedPlanId: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(plan.planname)
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding(.leading)
                    .padding(.top)
                Text("\(formatDate(plan.startdate)) - \(formatDate(plan.enddate))")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.top, 3)
                    .padding(.bottom)
                    .padding(.leading)
            }
            Spacer()
            Image(systemName: selectedPlanId == plan.id ? "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(selectedPlanId == plan.id ? Color(hex: "8F785C", alpha: 1.0) : .gray)
                .padding(.trailing, 10)
        }
        .frame(width: 280, height: 90)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: "8F785C", alpha: 1.0), lineWidth: 2)
        )
        .padding()
        .onTapGesture {
            self.selectedPlanId = plan.id
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}
