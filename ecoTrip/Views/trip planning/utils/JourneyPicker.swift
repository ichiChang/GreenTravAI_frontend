import SwiftUI

struct JourneyPicker: View {
    @State private var textInput = ""
    @State private var selectedPlanId: String?
    @State private var selectedDayId: String?
    @State private var showingDateSelector = false
    @EnvironmentObject var viewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showJPicker: Bool
    @State private var chatContent: String
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var recommendation: Recommendation?
    @Binding var navigateToPlanView: Bool

    init(showJPicker: Binding<Bool>, chatContent: String, recommendation: Recommendation?, navigateToPlanView: Binding<Bool>) {
        self._showJPicker = showJPicker
        self._chatContent = State(initialValue: chatContent)
        self._recommendation = State(initialValue: recommendation)
        self._navigateToPlanView = navigateToPlanView
    }
    
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

            if showingDateSelector, (viewModel.travelPlans.first(where: { $0.id == selectedPlanId }) != nil) {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.days) { day in
                            DateRowView(day: day, selectedDayId: $selectedDayId)
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

            if showingDateSelector && selectedDayId != nil {
                // Confirm button
                Button(action: {
                    addContentToTravelPlan()
                }) {
                    Text("添加到旅行計劃")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color(hex: "8F785C", alpha: 1.0))
                        .cornerRadius(15)
                }
                .padding()
            } else {
                // Confirm button
                Button(action: {
                    if showingDateSelector && selectedDayId != nil {
                        showJPicker = false
                    } else {
                        showingDateSelector = true
                        if let planId = selectedPlanId, let token = authViewModel.accessToken {
                            viewModel.fetchDaysForPlan(planId: planId, token: token)
                        }
                    }
                }) {
                    Text(showingDateSelector && selectedDayId != nil ? "完成" : "確認")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 40)
                        .background(Color(hex: "8F785C", alpha: 1.0))
                        .cornerRadius(15)
                }
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("提示"),
                message: Text(alertMessage),
                primaryButton: .default(Text("查看行程")) {
                    // 确保 selectedTravelPlan 被正确设置
                    if let selectedPlan = viewModel.travelPlans.first(where: { $0.id == selectedPlanId }) {
                        viewModel.selectedTravelPlan = selectedPlan
                    }
                    navigateToPlanView = true
                    showJPicker = false
                },
                secondaryButton: .cancel(Text("取消")) {
                    showJPicker = false
                }
            )
        }
        .onAppear {
            if let token = authViewModel.accessToken {
                viewModel.fetchTravelPlans(token: token)
            }
        }
    }

    private func addContentToTravelPlan() {
        guard let dayId = selectedDayId,
              let token = authViewModel.accessToken,
              let recommendation = recommendation else {
            showAlert(message: "無法添加內容：缺少必要資訊")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startTime = dateFormatter.string(from: Date())

        viewModel.getLastStopForDay(dayId: dayId, token: token) { lastStop in
            let prevStop = lastStop?.id ?? ""

            let requestBody: [String: Any] = [
                "Name": recommendation.Name,
                "StartTime": startTime,
                "note": "",
                "DayId": dayId,
                "latency": recommendation.Latency,
                "address": recommendation.Address,
                "prev_stop": prevStop
            ]


            viewModel.addStopToDay(requestBody: requestBody, token: token) { success, error in
                if success {
                    alertMessage = "成功添加到旅行計劃。是否查看該行程？"
                    showAlert = true
                } else {
                    showAlert(message: "添加失敗：\(error ?? "未知錯誤")")
                }
            }
        }
    }

    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
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
    let day: Day
    @Binding var selectedDayId: String?
    
    var body: some View {
        HStack {
            Text(day.date)
                .bold()
                .padding()
            Spacer()
            Image(systemName: selectedDayId == day.id ? "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(selectedDayId == day.id ? Color(hex: "8F785C", alpha: 1.0) : .gray)
        }
        .frame(width: 280)
        .padding(.top, 10)
        .onTapGesture {
            self.selectedDayId = day.id
        }
        Divider()
            .frame(width: 280)
            .frame(minHeight: 2)
            .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
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
