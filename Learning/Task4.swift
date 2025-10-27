//
//  Task4.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 24/10/2025.
//
// 

import SwiftUI

struct Task4: View {
    @State private var goToTask2 = false
    @Environment(\.dismiss) var dismiss
    @State private var goalText: String = ""
    @State private var selectedDuration: String = "Month"
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {NavigationLink(destination: Task2View(goalSubject: $goalText, goalDuration: $selectedDuration), isActive: $goToTask2) {
                EmptyView()
            }

                HStack{
                
                    Button {dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .frame(width: 40, height: 40)
                            .glassEffect()
                            .foregroundColor(.primary)
                           
                       
                    }
                   
                    Spacer()
                      VStack(alignment: .leading, spacing: 24){    Text("Learning Goal")
                            .font(.title)
                          .foregroundColor(.primary)}
                    Spacer()
                    HStack() {
                        Button {
                            showConfirmation = true
                        } label: {
                            Image(systemName: "checkmark")
                                .padding(.horizontal,10)
                                .padding(.vertical,10)
                                .foregroundColor(Color.orange).frame(width: 40, height: 40)
                                .glassEffect()
                                .background(Color.orange)
                                .clipShape(Circle())
                            
                        }.shadow(color: .orange.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                }
                
                Text("I want to learn")
                    .font(.headline)
                    .foregroundColor(.primary.opacity(0.8))
                
                TextField("", text: $goalText)
                    .foregroundColor(.primary)
                    .padding(.vertical, 8)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.primary), alignment: .bottom)
                
                Text("I want to learn it in a")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 16) {
                    ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                        Button {
                            selectedDuration = duration
                        } label: {
                            Text(duration)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(
                                    Capsule()
                                        .fill(selectedDuration == duration ? Color.orange : Color.primary.opacity(0.3))
                                )
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground).ignoresSafeArea())
            .navigationTitle("Learning Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                   
                }
            }
            .overlay {
                if showConfirmation {
                    ZStack {
                        // Dimmed background
                        Color(.systemBackground).opacity(0.6)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showConfirmation = false
                            }

                        // Custom dark popup
                        VStack(spacing: 20) {
                            Text("Update Learning goal")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("If you update now, your streak will start over.")
                                .foregroundColor(.primary.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            HStack {
                                Button("Dismiss") {
                                    showConfirmation = false
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(20)

                                Button("Update") {
                                    showConfirmation = false
                                        goToTask2 = true                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.orange.opacity(0.7))
                                .cornerRadius(20)
                            }
                        }
                       .padding()
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(16)
                     .shadow(radius: 16)
                  .frame(maxWidth: 300)
                 // .glassEffect()
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: showConfirmation)
                }
            }
            .navigationBarBackButtonHidden(true)

        }
    }
}

#Preview {
    Task4()
}

