# LKFeedbackGen

Will let you to handle iOS device feedback mechanism easily. Will automatically invoke Hapics/Taptic signals based on single call.

## Usage

**1.** Import LKFeedbackGen in proper place.
```swift
import LKFeedbackGen
```

**2.** Call feedback
```swift
LKFeedbackGen.feedback(signal: HapticSignal)
```

**HapticSignal**
```swift
case selection, light, medium, heavy, success, warn, error, cancelled
```


## Features

- [x] Easy to use
- [x] Fully customizable
- [x] Simple Swift syntax
- [x] Lightweight readable codebase


## ❤️ Contributing
This is an open source project, so feel free to contribute. How?
- Open an [issue](https://github.com/lalkrishna/LKFeedbackGen/issues/new).
- Send feedback via [email](mailto:lalkrishna@live.com).
- Propose your own fixes, suggestions and open a pull request with the changes.

## Author

Lal Krishna
[Twitter](http://www.twitter.com/itzme_lal)

## 👮🏻 License

```
MIT License

Copyright (c) 2019 Lal Krishna

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
