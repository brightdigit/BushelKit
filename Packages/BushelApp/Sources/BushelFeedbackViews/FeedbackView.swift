//
// FeedbackView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelFeedbackCore

  public import BushelFeedbackEnvironment
  import BushelLocalization
  import BushelViewsCore

  public import SwiftUI

  public struct FeedbackView: View, SingleWindowView {
    public typealias Value = ProvideFeedbackWindowValue

    @State var name: String = ""
    @State var email: String = ""
    @State var message: String = ""
    @Environment(\.dismiss) var dismiss

    public var body: some View {
      VStack {
        Text(localizedUsingID: LocalizedStringID.feedbackDescription)
          .lineLimit(4, reservesSpace: true)
          .multilineTextAlignment(.leading)
        LabeledContent {
          TextField("Leo Dion", text: self.$name)
        } label: {
          Text(.name)
        }.labeledContentStyle(.vertical())
        LabeledContent {
          TextField("leo@brightdigit.com", text: self.$email)
        } label: {
          Text(.feedbackEmail)
        }.labeledContentStyle(.vertical())
        TextField(text: self.$message, axis: .vertical) {
          Text(.feedbackMessage)
        }.lineLimit(3 ... 10).padding(.vertical, 8.0)
        HStack {
          Button(action: {
            Feedback.submit(FeedbackValue(message: message, name: name, email: email))
            dismiss()
          }, label: {
            Text(.feedbackSend)
          })
          Spacer()
          Button(action: {
            dismiss()
          }, label: {
            Text(.cancel)
          })
        }
      }
      .frame(width: 320)
      .padding()
    }

    public init() {}
  }

  #Preview {
    FeedbackView()
  }
#endif
