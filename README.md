# Sample Applications

## Make Money Outside the Mac App Store: How to Sell Your Mac App with FastSpring, Secure It With License Codes Against Piracy, and Offer Time-Based Trial Downloads

This is the manuscript of the book "[Make Money Outside the Mac App Store (With FastSpring)][book]".

[book]: https://christiantietze.de/books/make-money-outside-mac-app-store-fastspring/

## Installation / Set Up

If you run Git v1.6.5 or higher, you should be able to clone this repository recursively, including all submodules:

    $ git clone --recursive git@github.com:CleanCocoa/mac-licensing-fastspring-cocoafob.git

If that doesn't work, do it manually:

1. Clone this git repository on your computer
2. Initialize all submodules:
    
        $ git submodule update --init --recursive

### Project Configuration

Make sure to change `FastSpringCredentials.plist` file to your store settings to make the embedded store work.

## Dependencies

* [CocoaFob](https://github.com/glebd/cocoafob)
* [FastSpring Embedded Store SDK for Mac](https://github.com/DivineDominion/FsprgEmbeddedStoreMac) -- I forked the base repo for Swift support.

## License

See the LICENSE file for copy permissions.
