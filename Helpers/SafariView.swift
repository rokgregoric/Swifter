//
//  SafariView.swift
//
//  Created by Rok Gregorič.
//

#if os(iOS)
  import SafariServices
  import SwiftUI

  struct SafariView: UIViewControllerRepresentable {
    let url: URL
    var preferredControlTintColor: UIColor? = nil
    var preferredBarTintColor: UIColor? = nil
    var dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done
    var entersReaderIfAvailable = false
    var barCollapsingEnabled = true

    func makeUIViewController(context: Context) -> SFSafariViewController {
      let configuration = SFSafariViewController.Configuration()
      configuration.entersReaderIfAvailable = entersReaderIfAvailable
      configuration.barCollapsingEnabled = barCollapsingEnabled

      let controller = SFSafariViewController(url: url, configuration: configuration)
      update(controller)
      return controller
    }

    func updateUIViewController(
      _ controller: SFSafariViewController,
      context: Context
    ) {
      update(controller)
    }

    private func update(_ controller: SFSafariViewController) {
      controller.preferredControlTintColor = preferredControlTintColor
      controller.preferredBarTintColor = preferredBarTintColor
      controller.dismissButtonStyle = dismissButtonStyle
    }
  }
#endif
