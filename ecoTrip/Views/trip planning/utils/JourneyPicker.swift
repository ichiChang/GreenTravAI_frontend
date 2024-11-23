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
    @State private var showCustomAlert = false // State to control CustomAlertView
    @State private var alertTitle = "" // Custom alert title
    @State private var alertMessage = "" // Custom alert message
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
            VStack(spacing: 20) {
                // Close button
                Button(action: {
                    showJPicker = false
                }, label: {
                    HStack {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(hex: "8F785C", alpha: 1.0))
                        Spacer()
                    }
                    .frame(width: 280)
                })
                .padding()
                
                // Title text
                Text(showingDateSelector ? "請選擇日期" : "請選擇旅行計劃")
                    .font(.system(size: 20))
                
                // Travel plans list or date selector
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
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))

                            } else if let error = viewModel.error {
                                Text("Error: \(error)")
                            } else if viewModel.travelPlans.isEmpty {
                                Text("No travel plans found")
                            } else {
                                ForEach(viewModel.travelPlans) { plan in
                                    PlanRowView2(plan: plan, selectedPlanId: $selectedPlanId)
                                }
                            }
                        }
                    }
                }
                
                // Confirm button
                Button(action: {
                    if showingDateSelector && selectedDayId != nil {
                        addContentToTravelPlan()
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
            .popupNavigationView(horizontalPadding: 40, show: $showCustomAlert) {
                CustomAlertView(isPresented: $showCustomAlert, title: alertTitle, message: alertMessage, primaryButtonText: "查看行程", secondaryButtonText: "取消", primaryButtonAction: {
                    if let selectedPlan = viewModel.travelPlans.first(where: { $0.id == selectedPlanId }) {
                        viewModel.selectedTravelPlan = selectedPlan
                    }
                    navigateToPlanView = true
                    showJPicker = false
                }, secondaryButtonAction: {
                    showJPicker = false
                })
            }
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
            showAlert(title: "無法添加內容", message: "無法添加內容：缺少必要資訊")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startTime = dateFormatter.string(from: Date())

        viewModel.getLastStopForDay(dayId: dayId, token: token) { lastStop in
            let prevStop = lastStop?.id ?? ""

            let requestBody: [String: Any] = [
                "Name": recommendation.Location,
                "StartTime": startTime,
                "note": recommendation.description,
                "DayId": dayId,
                "latency": recommendation.latency,
                "address": recommendation.Address,
                "prev_stop": prevStop
            ]

            viewModel.addStopToDay(requestBody: requestBody, token: token) { success, error in
                if success {
                    alertTitle = "行程增加成功"
                    alertMessage = "您的行程已成功新增至旅行計劃中。\n是否查看該行程？"
                    showCustomAlert = true
                } else {
                    showAlert(title: "行程增加失敗", message: "添加失敗：\(error ?? "未知錯誤")")
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showCustomAlert = true
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

