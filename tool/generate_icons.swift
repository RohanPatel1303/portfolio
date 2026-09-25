// Generates every app and web icon from one design: a white "RP" monogram in
// Bricolage Grotesque (the site's display face) on the default seed colour.
//
//   swift tool/generate_icons.swift        (run from the repo root, on macOS)
//
// Written against CoreGraphics/CoreText rather than adding
// flutter_launcher_icons, so the project gains no dependency and the design
// lives in code instead of in a hand-exported PNG.

import AppKit
import CoreText
import Foundation

// Keep in sync with seedOptions.first in lib/state/settings.dart.
let tileColor = CGColor(srgbRed: 0xFF / 255, green: 0x3D / 255, blue: 0x7F / 255, alpha: 1)
let inkColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
let monogram = "RP"

let fontURL = URL(string:
  "https://github.com/google/fonts/raw/main/ofl/bricolagegrotesque/BricolageGrotesque%5Bopsz,wdth,wght%5D.ttf")!

// MARK: - Font

func loadFont() -> CTFontDescriptor {
  guard let data = try? Data(contentsOf: fontURL),
        let base = CTFontManagerCreateFontDescriptorFromData(data as CFData) else {
    fatalError("Could not download Bricolage Grotesque from \(fontURL)")
  }
  // Variable font: pin weight and optical size. opsz at its max gives the
  // tighter display cut the site's headings use.
  let axes: [(String, Double)] = [("wght", 800), ("opsz", 96)]
  return axes.reduce(base) { desc, axis in
    let tag = axis.0.utf8.reduce(0) { ($0 << 8) | UInt32($1) }
    return CTFontDescriptorCreateCopyWithVariation(desc, NSNumber(value: tag), CGFloat(axis.1))
  }
}

let fontDescriptor = loadFont()

// MARK: - Drawing

enum Style {
  /// Opaque square, no rounding. iOS and maskable web icons: the OS applies
  /// its own mask, and iOS rejects icons with alpha.
  case fullBleed
  /// Rounded tile on transparent. Favicon, Windows, Linux, legacy Android.
  case rounded
  /// Apple's macOS grid: 824pt tile inset in a 1024pt canvas, with shadow.
  case macOS
  /// Android adaptive foreground: glyphs only, sized for the 72/108 visible
  /// area so launcher masks and parallax never crop them.
  case adaptiveForeground
}

func drawMonogram(in ctx: CGContext, tile: CGRect) {
  // Tiny sizes get bigger letters: at 16px, proportions tuned for 1024px
  // leave strokes under a pixel wide.
  let scale: CGFloat = tile.width <= 48 ? 0.60 : 0.50
  let font = CTFontCreateWithFontDescriptor(fontDescriptor, tile.width * scale, nil)
  let attrs: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key(kCTFontAttributeName as String): font,
    NSAttributedString.Key(kCTForegroundColorAttributeName as String): inkColor,
    // Matches the -0.02em tracking on display text in lib/app/theme.dart.
    NSAttributedString.Key(kCTKernAttributeName as String): -0.02 * tile.width * scale,
  ]
  let line = CTLineCreateWithAttributedString(NSAttributedString(string: monogram, attributes: attrs))
  // Centre on the ink, not the typographic box, or the letters sit high.
  let ink = CTLineGetImageBounds(line, ctx)
  ctx.textPosition = CGPoint(x: tile.midX - ink.midX, y: tile.midY - ink.midY)
  CTLineDraw(line, ctx)
}

func render(_ px: Int, _ style: Style) -> Data {
  let opaque = style == .fullBleed
  let ctx = CGContext(
    data: nil, width: px, height: px, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpace(name: CGColorSpace.sRGB)!,
    bitmapInfo: opaque ? CGImageAlphaInfo.noneSkipLast.rawValue : CGImageAlphaInfo.premultipliedLast.rawValue)!
  let size = CGFloat(px)
  let canvas = CGRect(x: 0, y: 0, width: size, height: size)

  switch style {
  case .fullBleed:
    ctx.setFillColor(tileColor)
    ctx.fill(canvas)
    drawMonogram(in: ctx, tile: canvas)
  case .rounded:
    // Squarer corners when small, so the tile doesn't read as a circle.
    let radius = size * (px <= 32 ? 0.18 : 0.225)
    ctx.addPath(CGPath(roundedRect: canvas, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.setFillColor(tileColor)
    ctx.fillPath()
    drawMonogram(in: ctx, tile: canvas)
  case .macOS:
    let tile = canvas.insetBy(dx: size * 100 / 1024, dy: size * 100 / 1024)
    let radius = tile.width * 0.225
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -size * 10 / 1024), blur: size * 20 / 1024,
                  color: CGColor(gray: 0, alpha: 0.3))
    ctx.addPath(CGPath(roundedRect: tile, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.setFillColor(tileColor)
    ctx.fillPath()
    ctx.restoreGState()
    drawMonogram(in: ctx, tile: tile)
  case .adaptiveForeground:
    let visible = size * 72 / 108
    drawMonogram(in: ctx, tile: canvas.insetBy(dx: (size - visible) / 2, dy: (size - visible) / 2))
  }

  let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
  return rep.representation(using: .png, properties: [:])!
}

func write(_ path: String, _ px: Int, _ style: Style) {
  let url = URL(fileURLWithPath: path)
  try! FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
  try! render(px, style).write(to: url)
  print("  \(path) (\(px)px)")
}

/// ICO with PNG-compressed entries, supported since Windows Vista.
func writeICO(_ path: String, sizes: [Int]) {
  let images = sizes.map { render($0, .rounded) }
  var out = Data()
  func le16(_ v: Int) { out.append(contentsOf: [UInt8(v & 0xFF), UInt8(v >> 8 & 0xFF)]) }
  func le32(_ v: Int) { le16(v & 0xFFFF); le16(v >> 16) }
  le16(0); le16(1); le16(images.count)
  var offset = 6 + 16 * images.count
  for (px, png) in zip(sizes, images) {
    out.append(UInt8(px >= 256 ? 0 : px))  // 0 means 256
    out.append(UInt8(px >= 256 ? 0 : px))
    out.append(contentsOf: [0, 0])          // palette, reserved
    le16(1); le16(32)                       // planes, bpp
    le32(png.count); le32(offset)
    offset += png.count
  }
  images.forEach { out.append($0) }
  try! out.write(to: URL(fileURLWithPath: path))
  print("  \(path) (\(sizes.map(String.init).joined(separator: ", "))px)")
}

// MARK: - Targets

print("Web")
write("web/favicon.png", 48, .rounded)
write("web/icons/Icon-192.png", 192, .rounded)
write("web/icons/Icon-512.png", 512, .rounded)
write("web/icons/Icon-maskable-192.png", 192, .fullBleed)
write("web/icons/Icon-maskable-512.png", 512, .fullBleed)
write("web/icons/apple-touch-icon.png", 180, .fullBleed)

print("Android")
for (density, dp1) in [("mdpi", 1.0), ("hdpi", 1.5), ("xhdpi", 2.0), ("xxhdpi", 3.0), ("xxxhdpi", 4.0)] {
  let res = "android/app/src/main/res/mipmap-\(density)"
  write("\(res)/ic_launcher.png", Int(48 * dp1), .rounded)
  write("\(res)/ic_launcher_foreground.png", Int(108 * dp1), .adaptiveForeground)
}

print("iOS")
let iosSet = "ios/Runner/Assets.xcassets/AppIcon.appiconset"
for (pt, scales) in [(20.0, [1, 2, 3]), (29.0, [1, 2, 3]), (40.0, [1, 2, 3]), (60.0, [2, 3]),
                     (76.0, [1, 2]), (83.5, [2]), (1024.0, [1])] {
  for s in scales {
    let name = pt == 83.5 ? "83.5x83.5" : "\(Int(pt))x\(Int(pt))"
    write("\(iosSet)/Icon-App-\(name)@\(s)x.png", Int(pt * Double(s)), .fullBleed)
  }
}

print("macOS")
for px in [16, 32, 64, 128, 256, 512, 1024] {
  write("macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_\(px).png", px, .macOS)
}

print("Windows")
writeICO("windows/runner/resources/app_icon.ico", sizes: [16, 24, 32, 48, 64, 128, 256])

print("Linux")
write("linux/runner/resources/app_icon.png", 256, .rounded)
