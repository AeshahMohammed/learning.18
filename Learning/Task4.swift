//
//  Task4.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 24/10/2025.
//
import SwiftUI

struct LearningGoalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var goalText: String = ""
    @State private var selectedDuration: String = "Month"
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                HStack{
                
                    Button {
                        showConfirmation = true
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .frame(width: 40, height: 40)
                            .glassEffect()
                            .foregroundColor(.black)
                           
                       
                    }
                   
                    Spacer()
                      VStack(alignment: .leading, spacing: 24){    Text("Learning Goal")
                            .font(.title)
                          .foregroundColor(.white)}
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
                    .foregroundColor(.white.opacity(0.8))
                
                TextField("", text: $goalText)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                
                Text("I want to learn it in a")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                
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
                                        .fill(selectedDuration == duration ? Color.orange : Color.gray.opacity(0.3))
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
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
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showConfirmation = false
                            }

                        // Custom dark popup
                        VStack(spacing: 20) {
                            Text("Update Learning goal")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("If you update now, your streak will start over.")
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            HStack {
                                Button("Dismiss") {
                                    showConfirmation = false
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.7))
                                .cornerRadius(20)

                                Button("Update") {
                                    dismiss()
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.orange)
                                .cornerRadius(20)
                            }
                        }
                       .padding()
                        .background(Color(.darkGray).opacity(0.9))
                        .cornerRadius(16)
                     .shadow(radius: 16)
                  .frame(maxWidth: 300)
                 // .glassEffect()
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: showConfirmation)
                }
            }

        }
    }
}

#Preview {
    LearningGoalView()
}

