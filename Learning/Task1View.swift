//
//  Task1View.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//



import SwiftUI

struct Task1View: View {
    @StateObject private var viewModel = Task1ViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    // MARK: - App logo
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "flame.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.orange.opacity(1.0))
                                .frame(width: 50, height: 50)
                        )
                        .glassEffect() // ✅ keep your custom effect
                    
                    // MARK: - Intro Texts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello Learner")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        Text("This app will help you learn everyday!")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: - Learning Subject
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn")
                            .foregroundColor(.primary)
                            .font(.headline)
                        
                        TextField("Enter your subject", text: $viewModel.subject)
                            .textFieldStyle(.plain)
                            .padding(.vertical, 8)
                        
                        Divider()
                            .background(Color.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: - Duration Picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn it in a")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        
                        HStack(spacing: 8) {
                            ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                                Button(action: {
                                    viewModel.selectedDuration = duration
                                }) {
                                    Text(duration)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 15)
                                        .glassEffect(.clear)
                                        .background(
                                            Capsule()
                                                .fill(viewModel.selectedDuration == duration
                                                      ? Color.darkOrange.opacity(0.9)
                                                      : Color.gray.opacity(0.05))
                                        )
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // MARK: - Start Button
                    NavigationLink(
                        destination: Task2View(
                            goalSubject: $viewModel.subject,
                            goalDuration: $viewModel.selectedDuration
                        )
                    ) {
                        Text("Start learning")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: 182, maxHeight: 48)
                            .foregroundColor(.primary)
                            .cornerRadius(30)
                            .glassEffect(.clear.tint(Color.orange.opacity(1.0)))
                            .background(.clear)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                }
            }
        }
    }
}

#Preview {
    Task1View()
}
