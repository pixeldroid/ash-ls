# ash-ls

A Loom port of the Ash entity system framework.

> Loom: https://www.loomsdk.com <br>
> Ash: http://www.ashframework.org

### Prior work

This project is based on a port by [ghroot](https://github.com/ghroot/AshLoom), makes a few minor changes and documentation tweaks, adds the Ash test suite, and provides pre-compiled `.loomlib` downloads for current Loom SDKs.


## Installation

Download the library into its matching sdk folder:

```bash
$ curl -L -o ~/.loom/sdks/sprint31/libs/Ash.loomlib \
    https://github.com/pixeldroid/ash-ls/releases/download/0.9.0/Ash-sprint31.loomlib
```

To uninstall, simply delete the loomlib file:

```bash
$ rm ~/.loom/sdks/sprint31/libs/Ash.loomlib
```


## Usage

The API mirrors the [original ActionScript version][ash-as], with the following exceptions:

#### Delegates instead of Signals

[Loom delegates][delegates-ls] are used instead of [Ash Signals][signals-ash]:

```
var nodeList:NodeList = engine.getNodeList(MyNode);
nodeList.nodeAdded += onNodeAdded;

private function onNodeAdded(node:Node):void
{
	// ...
}
```

#### Types instead of Classes

Loom uses `Type` where ActionScript uses `Class` to hold type information, so entity lookups are by Type, not Class.

#### Fetch instead of Get

Loom does not allow methods named `get`, so the `Entity` API was changed to use `fetch()`:

* `public function fetch(componentClass:Type):Object`
* `public function fetchAll(componentClass:Type):Vector.<Object>`

## Compiling from source

```
$ rake lib:install
```

### Dependencies

* the Ash library has no external dependencies
* the Test app depends on the [spec-ls library][spec-ls]
* the build system uses [loom tasks][loomtasks]


[ash-as]: http://www.ashframework.org "ash entity framework"
[delegates-ls]: http://docs.theengine.co/loom/1.1.3452/guides/02_LoomScript/02_syntax.html#toc_16 "LoomScript Language Reference: Delegates"
[signals-ash]: https://github.com/richardlord/Ash/tree/master/src/ash/signals "Ash Signals"
[spec-ls]: https://github.com/pixeldroid/spec-ls "a simple spec framework for Loom"
[loomtasks]: https://github.com/pixeldroid/loomtasks "Rake tasks for working with loomlibs"
