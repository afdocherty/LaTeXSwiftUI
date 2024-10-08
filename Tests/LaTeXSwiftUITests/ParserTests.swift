//
//  ParserTests.swift
//  
//
//  Created by Colin Campbell on 5/29/23.
//

import MathJaxSwift
import XCTest
@testable import LaTeXSwiftUI

final class ParserTests: XCTestCase {

  func assertComponent(_ components: [Component], _ index: Int, _ text: String, _ type: Component.ComponentType, file: StaticString = #file, line: UInt = #line) {
    guard index < components.count else {
      XCTFail()
      return
    }
    XCTAssertEqual(components[index], Component(text: text, type: type))
  }
  
  func testParseEmpty() {
    let input = ""
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 0)
  }
  
  func testParseTextOnly() {
    let input = "Hello, World!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    XCTAssertEqual(components[0].text, input)
  }

  func testParseBoldTextOnly() {
    let input = "#bold{Hello, World!}"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    XCTAssertEqual(components[0].text, "Hello, World!")
    assertComponent(components, 0, "Hello, World!", .boldText)
  }

  func testParseTextAndBoldText() {
    let input = "Before #bold{Hello, World!} After"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    XCTAssertEqual(components[0].text + components[1].text + components[2].text, "Before Hello, World! After")
    assertComponent(components, 0, "Before ", .text)
    assertComponent(components, 1, "Hello, World!", .boldText)
    assertComponent(components, 2, " After", .text)
  }
    
    func testParseitalicTextOnly() {
      let input = "#italic{Hello, World!}"
      let components = Parser.parse(input)
      XCTAssertEqual(components.count, 1)
      XCTAssertEqual(components[0].text, "Hello, World!")
      assertComponent(components, 0, "Hello, World!", .italicText)
    }

    func testParseTextAndItalicText() {
      let input = "Before #italic{Hello, World!} After"
      let components = Parser.parse(input)
      XCTAssertEqual(components.count, 3)
      XCTAssertEqual(components[0].text + components[1].text + components[2].text, "Before Hello, World! After")
      assertComponent(components, 0, "Before ", .text)
      assertComponent(components, 1, "Hello, World!", .italicText)
      assertComponent(components, 2, " After", .text)
    }
    
    func testParseUnderlineTextOnly() {
      let input = "#underline{Hello, World!}"
      let components = Parser.parse(input)
      XCTAssertEqual(components.count, 1)
      XCTAssertEqual(components[0].text, "Hello, World!")
      assertComponent(components, 0, "Hello, World!", .underlineText)
    }

    func testParseTextAndUnderlineText() {
      let input = "Before #underline{Hello, World!} After"
      let components = Parser.parse(input)
      XCTAssertEqual(components.count, 3)
      XCTAssertEqual(components[0].text + components[1].text + components[2].text, "Before Hello, World! After")
      assertComponent(components, 0, "Before ", .text)
      assertComponent(components, 1, "Hello, World!", .underlineText)
      assertComponent(components, 2, " After", .text)
    }
    
    func testParseTextWithBolditalicUnderline() {
      let input = "Bold #bold{Hello, World!} Italic #italic{Hello, World!} Underline #underline{Hello, World!}"
      let components = Parser.parse(input)
      XCTAssertEqual(components.count, 6)
      XCTAssertEqual(components[0].text
                     + components[1].text
                     + components[2].text
                     + components[3].text
                     + components[4].text
                     + components[5].text, "Bold Hello, World! Italic Hello, World! Underline Hello, World!")
      assertComponent(components, 0, "Bold ", .text)
      assertComponent(components, 1, "Hello, World!", .boldText)
      assertComponent(components, 2, " Italic ", .text)
      assertComponent(components, 3, "Hello, World!", .italicText)
      assertComponent(components, 4, " Underline ", .text)
      assertComponent(components, 5, "Hello, World!", .underlineText)
    }
  
  func testParseDollarOnly() {
    let input = "$\\TeX$"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, "\\TeX", .inlineEquation)
  }
  
  func testParseDollarOnly_Normal() {
    let input = "Hello, $\\TeX$!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 0, "Hello, ", .text)
    assertComponent(components, 1, "\\TeX", .inlineEquation)
    assertComponent(components, 2, "!", .text)
  }
  
  func testParseDollarOnly_LeftEscaped() {
    let input = "Hello, \\$\\TeX$!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseDollarOnly_RightEscaped() {
    let input = "Hello, $\\TeX\\$!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseDoubleDollarOnly() {
    let input = "$$\\TeX$$"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, "\\TeX", .texEquation)
  }
  
  func testParseDoubleDollarOnly_Normal() {
    let input = "Hello, $$\\TeX$$!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 0, "Hello, ", .text)
    assertComponent(components, 1, "\\TeX", .texEquation)
    assertComponent(components, 2, "!", .text)
  }
  
  func testParseDoubleDollarOnly_LeftEscaped() {
    let input = "Hello, \\$$\\TeX$$!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseDoubleDollarOnly_RightEscaped() {
    let input = "Hello, $$\\TeX\\$$!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseDoubleDollarOnly_LeadingLineBreak() {
    let equation = "\nf(x)=5x+2"
    let input = "$$\(equation)$$"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, equation, .texEquation)
  }
  
  func testParseDoubleDollarOnly_TrailingLineBreak() {
    let equation = "f(x)=5x+2\n"
    let input = "$$\(equation)$$"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, equation, .texEquation)
  }
  
  func testParseDoubleDollarOnly_Whitespace() {
    let equation = " \nf(x)=5x+2\n "
    let input = "$$\(equation)$$"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, equation, .texEquation)
  }
  
  func testParseBracketsOnly() {
    let input = "\\[\\TeX\\]"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, "\\TeX", .blockEquation)
  }
  
  func testParseBracketsOnly_Normal() {
    let input = "Hello, \\[\\TeX\\]!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 0, "Hello, ", .text)
    assertComponent(components, 1, "\\TeX", .blockEquation)
    assertComponent(components, 2, "!", .text)
  }
  
  func testParseBracketsOnly_LeftEscaped() {
    let input = "Hello, \\\\[\\TeX\\]!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseBracketsOnly_RightEscaped() {
    let input = "Hello, \\[\\TeX\\\\]!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseBracketsOnly_LeadingLineBreak() {
    let equation = "\n\\TeX"
    let input = "Hello, \\[\(equation)\\]!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .blockEquation)
  }
  
  func testParseBracketsOnly_TrailingLineBreak() {
    let equation = "\\TeX\n"
    let input = "Hello, \\[\(equation)\\]!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .blockEquation)
  }
  
  func testParseBracketsOnly_Whitespace() {
    let equation = " \n\\TeX\n "
    let input = "Hello, \\[\(equation)\\]!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .blockEquation)
  }
  
  func testParseBeginEndOnly() {
    let input = "\\begin{equation}\\TeX\\end{equation}"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, "\\TeX", .namedEquation)
  }
  
  func testParseBeginEndOnly_Normal() {
    let input = "Hello, \\begin{equation}\\TeX\\end{equation}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 0, "Hello, ", .text)
    assertComponent(components, 1, "\\TeX", .namedEquation)
    assertComponent(components, 2, "!", .text)
  }
  
  func testParseBeginEndOnly_LeftEscaped() {
    let input = "Hello, \\\\begin{equation}\\TeX\\end{equation}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseBeginEndOnly_RightEscaped() {
    let input = "Hello, \\begin{equation}\\TeX\\\\end{equation}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseBeginEndOnly_LeadingLineBreak() {
    let equation = "\n\\TeX"
    let input = "Hello, \\begin{equation}\(equation)\\end{equation}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .namedEquation)
  }
  
  func testParseBeginEndOnly_TrailingLineBreak() {
    let equation = "\\TeX\n"
    let input = "Hello, \\begin{equation}\(equation)\\end{equation}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .namedEquation)
  }
  
  func testParseBeginEndOnly_Whitespace() {
    let equation = " \n\\TeX\n "
    let input = "Hello, \\begin{equation}\(equation)\\end{equation}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .namedEquation)
  }
  
  func testMultipleBeginEnd() {
    let input = """
\\begin{equation}
  E = mc^2
\\end{equation}

\\begin{equation}
  E = mc^2
\\end{equation}
"""
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 0, "\n  E = mc^2\n", .namedEquation)
  }
  
  func testParseBeginEndStarOnly() {
    let input = "\\begin{equation*}\\TeX\\end{equation*}"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, "\\TeX", .namedNoNumberEquation)
  }
  
  func testParseBeginEndStarOnly_Normal() {
    let input = "Hello, \\begin{equation*}\\TeX\\end{equation*}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 0, "Hello, ", .text)
    assertComponent(components, 1, "\\TeX", .namedNoNumberEquation)
    assertComponent(components, 2, "!", .text)
  }
  
  func testParseBeginEndStarOnly_LeftEscaped() {
    let input = "Hello, \\\\begin{equation*}\\TeX\\end{equation*}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseBeginEndStarOnly_RightEscaped() {
    let input = "Hello, \\begin{equation*}\\TeX\\\\end{equation*}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 1)
    assertComponent(components, 0, input, .text)
  }
  
  func testParseBeginEndStarOnly_LeadingLineBreak() {
    let equation = "\n\\TeX"
    let input = "Hello, \\begin{equation*}\(equation)\\end{equation*}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .namedNoNumberEquation)
  }
  
  func testParseBeginEndStarOnly_TrailingLineBreak() {
    let equation = "\\TeX\n"
    let input = "Hello, \\begin{equation*}\(equation)\\end{equation*}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .namedNoNumberEquation)
  }
  
  func testParseBeginEndStarOnly_Whitespace() {
    let equation = " \n\\TeX\n "
    let input = "Hello, \\begin{equation*}\(equation)\\end{equation*}!"
    let components = Parser.parse(input)
    XCTAssertEqual(components.count, 3)
    assertComponent(components, 1, equation, .namedNoNumberEquation)
  }

}
