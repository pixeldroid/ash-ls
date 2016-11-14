ash-ls
======

a [LoomScript][loom-sdk] port of the [Ash][ash-as] entity system framework

- [installation](#installation)
- [usage](#usage)
- [building](#building)
- [contributing](#contributing)


### prior work

This project is based on a port by [ghroot](https://github.com/ghroot/AshLoom), makes a few minor changes and documentation tweaks, adds the Ash test suite, and provides pre-compiled `.loomlib` downloads for current Loom SDKs.


## installation

Download the library into its matching sdk folder:

    $ curl -L -o ~/.loom/sdks/sprint34/libs/Ash.loomlib \
        https://github.com/pixeldroid/ash-ls/releases/download/v0.10.0/Ash-sprint34.loomlib

To uninstall, simply delete the file:

    $ rm ~/.loom/sdks/sprint34/libs/Ash.loomlib


## usage

The API mirrors the [original ActionScript version][ash-as], with the following exceptions:

#### delegates instead of signals

[Loom delegates][delegates-ls] are used instead of [Ash Signals][signals-ash]:

```ls
var nodeList:NodeList = engine.getNodeList(MyNode);
nodeList.nodeAdded += onNodeAdded;

private function onNodeAdded(node:Node):void
{
    // ...
}
```

#### Types instead of Classes

Loom uses `Type` where ActionScript uses `Class` to hold type information, so entity lookups are by Type, not Class.

#### fetch instead of get

Loom does not allow methods named `get`, so the `Entity` API was changed to use `fetch()`:

* `public function fetch(componentClass:Type):Object`
* `public function fetchAll(componentClass:Type):Vector.<Object>`


## building

first, install [loomtasks][loomtasks] and the [spec-ls library][spec-ls]

### compiling from source

    $ rake lib:install

this will build the Ash library and install it in the currently configured sdk

### running tests

    $ rake test

this will build the Ash library, install it in the currently configured sdk, build the test app, and run the test app.


## contributing

Pull requests are welcome!


[ash-as]: http://www.ashframework.org "a high-performance entity system framework for game development"
[delegates-ls]: http://docs.theengine.co/loom/1.1.4813/guides/02_LoomScript/02_syntax.html#toc_16 "LoomScript Language Reference: Delegates"
[signals-ash]: https://github.com/richardlord/Ash/tree/master/src/ash/signals "Ash Signals"
[spec-ls]: https://github.com/pixeldroid/spec-ls "a simple spec framework for Loom"
[loom-sdk]: https://github.com/LoomSDK/LoomSDK "a native mobile app and game framework"
[loomtasks]: https://github.com/pixeldroid/loomtasks "Rake tasks for working with loomlibs"
