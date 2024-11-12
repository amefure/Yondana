// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Localizable.strings
  ///   StudyBookApp
  /// 
  ///   Created by t&a on 2024/11/02.
  internal static let dateLocale = L10n.tr("Localizable", "date_locale", fallback: "ja_JP")
  /// Asia/Tokyo
  internal static let dateTimezone = L10n.tr("Localizable", "date_timezone", fallback: "Asia/Tokyo")
  /// アプリの不具合はこちら
  internal static let settingSectionLinkContact = L10n.tr("Localizable", "setting_section_link_contact", fallback: "アプリの不具合はこちら")
  /// ・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。
  internal static let settingSectionLinkDesc = L10n.tr("Localizable", "setting_section_link_desc", fallback: "・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。")
  /// 「YONDANA」をオススメする
  internal static let settingSectionLinkRecommend = L10n.tr("Localizable", "setting_section_link_recommend", fallback: "「YONDANA」をオススメする")
  /// アプリをレビューする
  internal static let settingSectionLinkReview = L10n.tr("Localizable", "setting_section_link_review", fallback: "アプリをレビューする")
  /// 参考書を記録できるアプリだよ♫
  internal static let settingSectionLinkShareText = L10n.tr("Localizable", "setting_section_link_share_text", fallback: "参考書を記録できるアプリだよ♫")
  /// 利用規約とプライバシーポリシー
  internal static let settingSectionLinkTerms = L10n.tr("Localizable", "setting_section_link_terms", fallback: "利用規約とプライバシーポリシー")
  /// Link
  internal static let settingSectionLinkTitle = L10n.tr("Localizable", "setting_section_link_title", fallback: "Link")
  /// 設定
  internal static let settingTitle = L10n.tr("Localizable", "setting_title", fallback: "設定")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
