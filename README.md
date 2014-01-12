# ash-ls

A Loom port of the Ash entity system framework.

> Loom: https://www.loomsdk.com <br>
> Ash: http://www.ashframework.org

Original port by [ghroot](https://github.com/ghroot/AshLoom).

This port adds the Ash test suite and provides pre-compiled `.loomlib` downloads for current Loom SDKs.


## installation

Download the library into its matching sdk folder:

```bash
$ curl -L -o ~/.loom/sdks/sprint31/libs/Ash.loomlib \
    https://github.com/pixeldroid/ash-ls/releases/download/0.9.0/Ash-sprint31.loomlib
```

To uninstall, simply delete the file:

```bash
$ rm ~/.loom/sdks/sprint31/libs/Ash.loomlib
```


## Usage

The API is identical to the [original ActionScript version](http://www.ashframework.org), with the following exceptions.

### Delegates instead of Signals

[Loom delegates](http://www.youtube.com/watch?v=h83QPCOldbY) are used instead of [Ash Signals](https://github.com/richardlord/Ash/tree/master/src/ash/signals):

```
var nodeList:NodeList = engine.getNodeList(MyNode);
nodeList.nodeAdded += onNodeAdded;

private function onNodeAdded(node:Node):void
{
	// ...
}
```

### `Entity.getComponent()` instead of `Entity.get()`

Loom does not allow methods named `get`.


## Compiling from source

```
$ rake lib:install
```

### Dependencies

* the Ash library has no external dependencies
* the Test app depends on the [spec-ls library](https://github.com/pixeldroid/spec-ls)
