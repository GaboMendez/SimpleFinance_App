//
//  ExpenseChartsView.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 26/10/24.
//

import Charts
import SwiftUI

struct ExpenseChartsView: View {
  @State private var expeseByType: [ExpenseByType] = []
  @State private var expenseByMonth: [ExpenseByMonth] = []
  @State private var expenseTypeByMonth: [ExpenseTypeByMonth] = []

  @State private var animateChart = false

  var body: some View {
    ScrollView {
      VStack(spacing: 50) {
        GroupBox(
          label: Label(
            "Expense x Type",
            systemImage: "chart.pie.fill"
          )
        ) {
          donutChart
            .transition(.scale.combined(with: .opacity))
        }

        GroupBox(
          label: Label(
            "Expense x Month",
            systemImage: "chart.bar.xaxis.ascending"
          )
        ) {
          barChart
            .transition(.scale.combined(with: .opacity))
        }

        GroupBox(
          label: Label(
            "Expense x Type x Month",
            systemImage: "chart.bar.xaxis.ascending"
          )
        ) {
          stackedBarChart
            .transition(.scale.combined(with: .opacity))
        }
        
        GroupBox(
          label: Label(
            "Expense Trend",
            systemImage: "chart.line.uptrend.xyaxis"
          )
        ) {
          lineChart
            .transition(.scale.combined(with: .opacity))
        }
      }
      .padding()
      .task {
        do {
          let expenses = try await CoreDataPersistenceService.shared.getAll()
          let report = ExpenseReportService(expenses: expenses)

          expenseByMonth = report.expensesByMonth()
          expenseTypeByMonth = report.expenseTypeByMonth()
          expeseByType = report.expensesByType()

          withAnimation(.easeOut(duration: 1.2)) {
            animateChart = true
          }
        } catch {
          print("Error loading expenses: \(error)")
        }
      }
    }
    .navigationTitle("Charts")
  }

  private var stackedBarChart: some View {
    Chart {
      ForEach(expenseTypeByMonth) { item in
        BarMark(
          x: .value("Month", item.month),
          y: .value("Total", animateChart ? item.total : 0)
        )
        .foregroundStyle(by: .value("Type", item.type.title))
        .position(by: .value("Type", item.type.title))
      }
    }
    .chartForegroundStyleScale { title in
      if let type = ExpenseType.allCases.first(where: { $0.title == title }) {
        return type.color
      } else {
        return .gray
      }
    }
    .frame(width: 350, height: 350)
    .chartLegend(position: .bottom, alignment: .center, spacing: 8)
  }

  private var barChart: some View {
    Chart {
      ForEach(expenseByMonth) { item in
        BarMark(
          x: .value(
            "Month",
            item.month
          ),
          y: .value(
            "Total",
            animateChart ? item.total : 0
          )
        )
        .foregroundStyle(.blue.gradient)
        .cornerRadius(8)
      }
    }
    .frame(width: 350, height: 350)
    .chartLegend(position: .bottom, alignment: .center, spacing: 8)
  }
  
  private var lineChart: some View {
    Chart {
      ForEach(expenseByMonth) { item in
        LineMark(
          x: .value("Month", item.month),
          y: .value("Total", animateChart ? item.total : 0)
        )
        .foregroundStyle(.purple)
        .symbol(.circle)
        .interpolationMethod(.catmullRom)
        
        AreaMark(
          x: .value("Month", item.month),
          y: .value("Total", animateChart ? item.total : 0)
        )
        .foregroundStyle(.purple.opacity(0.2).gradient)
        .interpolationMethod(.catmullRom)
      }
    }
    .frame(width: 350, height: 350)
    .chartLegend(position: .bottom, alignment: .center, spacing: 8)
  }

  private var donutChart: some View {
    Chart(expeseByType) { item in
      SectorMark(
        angle: .value(
          Text(item.type.title),
          animateChart ? item.total : 0
        ),
        // Donut style
        innerRadius: .ratio(0.4),
        angularInset: 10
      )
      .position(by: .value("Total", item.total))
      .foregroundStyle(
        by: .value(
          Text(item.type.title),
          item.type.title
        )
      )
    }
    .chartForegroundStyleScale { title in
      if let type = ExpenseType.allCases.first(where: { $0.title == title }) {
        return type.color
      } else {
        return .black
      }
    }
    .frame(width: 350, height: 350)
    .chartLegend(position: .bottom, alignment: .center, spacing: 8)
  }
}

#Preview {
    ExpenseChartsView()
}



