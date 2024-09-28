//
//  MockTravelPlanViewModel.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/9/25.
//

// Mock ViewModel for Preview
class MockTravelPlanViewModel: TravelPlanViewModel {
    override init() {
        super.init()
        // Mock Data for preview
        self.travelPlans = [
            TravelPlan(id: "1", planname: "Sample Plan 1", startdate: "2024-09-10", enddate: "2024-09-15"),
            TravelPlan(id: "2", planname: "Sample Plan 2", startdate: "2024-10-01", enddate: "2024-10-05")
        ]
        self.isLoading = false  // 設置為不在加載狀態
    }
}
