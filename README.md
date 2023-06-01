# LaTeXSwiftUI

A SwiftUI view that renders LaTeX equations.

![Swift Version](https://img.shields.io/badge/Swift-5.7-orange?logo=swift) ![iOS Version](https://img.shields.io/badge/iOS-16-informational) ![macOS Version](https://img.shields.io/badge/macOS-13-informational)

<center><img src="./assets/images/device.png" height="362"></center>

## 📖 Contents

- [About](#ℹ️-about)
- [Installation](#📦-installation)
- [Usage](#⌨️-usage)
  - [Modifiers](#⚙️-modifiers)
    - [Parsing Mode](#🔤-parsing-mode)
    - [Image Rendering Mode](#🌄-image-rendering-mode)
    - [Error Mode](#🚨-error-mode)
    - [Block Rendering Mode](#🧱-block-rendering-mode)
    - [Numbered Block Equations](#🔢-numbered-block-equations)
      - [Equation Number Mode](#equation-number-mode)
      - [Equation Number Start](#equation-number-start)
      - [Equation Number Offset](#equation-number-offset)
    - [Unencode HTML](#🔗-unencode-html)
    - [TeX Options](#♾️-tex-options (deprecated))
  - [Caching](#🗄️-caching)
  - [Preloading](#🏃‍♀️-preloading)
  
## ℹ️ About

`LaTexSwiftUI` is a package that exposes a view named `LaTeX` that can parse and render TeX and LaTeX equations that contain math-mode marcos.

The view utilizes the [MathJaxSwift](https://www.github.com/colinc86/MathJaxSwift) package to render equations with [MathJax](https://www.mathjax.org). Thus, the limitations of the view are heavily influenced by the [limitations](https://docs.mathjax.org/en/v2.7-latest/tex.html#differences) of MathJax.

It will
- render TeX and LaTeX equations (math-mode macros),
- and render the `\text{}` macro within equations.

It won't
- render TeX and LaTeX documents (text-mode macros, with the exception of the rule above).

## 📦 Installation

Add the dependency to your package manifest file.

```swift
.package(url: "https://github.com/colinc86/LaTeXSwiftUI", from: "1.1.0")
```

## ⌨️ Usage

Import the package and use the view.

```swift
import LaTeXSwiftUI

struct MyView: View {

  var body: some View {
    LaTeX("Hello, $\\LaTeX$!")
  }

}
```

> <img src="./assets/images/hello.png" width="85" height="21.5">

### ⚙️ Modifiers

The `LaTeX` view's body is built up of `Text` views so feel free to use any of the supported modifiers.

```swift
LaTeX("Hello, $\\LaTeX$!")
  .fontDesign(.serif)
  .foregroundColor(.blue)
```

> <img src="./assets/images/hello_blue.png" width="87" height="21.5">

Along with supporting the built-in SwiftUI modifies, `LaTeXSwiftUI` defines more to let you configure the view.

#### 🔤 Parsing Mode

Text input can either be completely rendered, or the view can search for top-level equations delimited by the following terminators.

| Terminators |
|-------------|
| `$...$` |
| `$$...$$` |
| `\[...\]` |
| `\begin{equation}...\end{equation}` |
| `\begin{equation*}...\end{equation*}` |

 The default behavior is to only render equations with `onlyEquations`. Use the `parsingMode` modifier to change the default behavior.

```swift
// Only parse equations (default)
LaTeX("Euler's identity is $e^{i\\pi}+1=0$.")
  .font(.system(size: 18))
  .parsingMode(.onlyEquations)

// Parse the entire input
LaTeX("\\text{Euler's identity is } e^{i\\pi}+1=0\\text{.}")
  .parsingMode(.all)
```

> <img src="./assets/images/euler.png" width="293" height="80">

#### 🌄 Image Rendering Mode

You can specify the rendering mode of the rendered equations so that they either take on the style of the surrounding text or display the style rendered by MathJax. The default behavior is to use the `template` rendering mode so that images match surrounding text.

```swift
// Render images to match the surrounding text
LaTeX("Hello, $\\color{red}\\LaTeX$!")
  .imageRenderingMode(.template)

// Display the original rendered image
LaTeX("Hello, ${\\color{red} \\LaTeX}$!")
  .imageRenderingMode(.original)
```

> <img src="./assets/images/rendering_mode.png" width="84.5" height="43">

#### 🚨 Error Mode

When an error occurs while parsing the input the view will display the original LaTeX. You can change this behavior by modifying the view's `errorMode`.

> Note: when the `rendered` mode is used, MathJax is instructed to load the `noerrors` and `noundefined` packages. In the other two modes, `original` and `error`, these packages are not loaded by MathJax and errors are either displayed in the view, or caught and replaced with the original text.

```swift
// Display the original text instead of the equation
LaTeX("$\\asdf$")
  .errorMode(.original)

// Display the error text instead of the equation
LaTeX("$\\asdf$")
  .errorMode(.error)

// Display the rendered image (if available)
LaTeX("$\\asdf$")
  .errorMode(.rendered)
```

> <img src="./assets/images/errors.png" width="199.5" height="55">

#### 🧱 Block Rendering Mode

The typical "LaTeX-ish" way to render the input is with `blockViews`. This mode renders text as usual, and block equations as... blocks; on their own line and centered. MathJax 3 does not support line breaking, so the view places block equations in horizontal scroll views in case the width of the equation is more than the width of the view.

In the case that you want to force block equations as inline, you can use the `alwaysInline` mode. You can also keep block styling with `blockText`, but the blocks will not be centered in their views. These modes can be helpful if you have a lengthy input string and need to only display it on a single or few lines.

```swift
/// The default block mode 
LaTeX("The quadratic formula is $$x=\\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}$$ and it has zeros at the roots of $f(x)=ax^2+bx+c$.")
  .blockMode(.blockViews)

Divider()

/// Force blocks to render as inline
LaTeX("The quadratic formula is $$x=\\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}$$ and it has zeros at the roots of $f(x)=ax^2+bx+c$.")
  .blockMode(.alwaysInline)

Divider()

/// Force blocks to render as text with newlines
LaTeX("The quadratic formula is $$x=\\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}$$ and it has zeros at the roots of $f(x)=ax^2+bx+c$.")
  .blockMode(.blockText)
```

> <img src="./assets/images/blocks.png" width="430" height="350">

#### 🔢 Numbered Block Equations

The `LaTeX` view can do simple numbering of block equations with the `blockViews` block mode.

##### Equation Number Mode

Use the `equationNumberMode` modifier to change between `left`, `right` and `none`.

##### Equation Number Start

The default starting number is `1`, but if you need to start at a different value, you can specify it with the `equationNumberStart` modifier.

##### Equation Number Offset

To change the left or right offset of the equation number, use the `equationNumberOffset` modifier.

```swift
// Don't number block equations (default)
LaTeX("$$a + b = c$$")
  .equationNumberMode(.none)

// Add left numbers and a leading offset
LaTeX("$$d + e = f$$")
  .equationNumberMode(.left)
  .equationNumberOffset(10)

// Add right numbers, a leading offset, and start at 2
LaTeX("$$h + i = j$$ $$k + l = m$$")
  .equationNumberMode(.right)
  .equationNumberStart(2)
  .equationNumberOffset(20)
```

> <img src="./assets/images/numbers.png">

#### 🔗 Unencode HTML

Input may contain HTML entities such as `&lt;` which will not be parsed by LaTeX as anything meaningful. In this case, you may use the `unencoded` modifier.

```swift
LaTeX("$x^2&lt;1$")
  .errorMode(.error)

// Replace "&lt;" with "<"
LaTeX("$x^2&lt;1$")
  .unencoded()
```

> <img src="./assets/images/unencoded.png" width="72.5" height="34">

#### ♾️ TeX Options (deprecated)

For more control over the MathJax rendering, you can pass a `TeXInputProcessorOptions` object to the view.

```swift
LaTeX("Hello, $\\LaTeX$!")
  .texOptions(TeXInputProcessorOptions(loadPackages: [TeXInputProcessorOptions.Packages.base]))
```

### 🗄️ Caching

`LaTeXSwiftUI` caches its SVG responses from MathJax and the images rendered as a result of the view's environment. If you want to control the cache, then you can access the static `cache` property.

The caches are managed automatically, but if, for example, you wanted to clear the cache manually you may do so.

```swift
// Clear the SVG data cache.
LaTeX.dataCache?.removeAll()

// Clear the rendered image cache.
LaTeX.imageCache.removeAll()
```

`LaTeXSwiftUI` uses the [caching](https://github.com/kean/Nuke/tree/master/Sources/Nuke/Caching) components of the [Nuke](https://github.com/kean/Nuke) package.

### 🏃‍♀️ Preloading

SVGs and images are rendered and cached on demand, but there may be situations where you want to preload the data so that there is minimal lag when the view appears.

```swift
VStack {
  ForEach(expressions, id: \.self) { expression in
    LaTeX(expression)
      .preload()
  }
}
```

Keep in mind that SVG data and images are rendered as a result of the view's environment, so it is important to call the `preload` method using the same values that will be used when drawing the view.
