# Sample Applications

These are sample applications for the book "[Release a Mac App Outside the App Store with FastSpring and CocoaFob][book]".

[book]: https://leanpub.com/mac-app-licensing-fastspring-cocoafob/

## Installation / Set Up

If you run Git v.1.6.5 or higher, you should be able to clone this repository recirsively, including all submodules:

    $ git clone --recursive git@github.com:DivineDominion/mac-licensing-fastspring-cocoafob-book.git

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
