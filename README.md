# ash-ls

A Loom port of the Ash entity system framework.

> Loom: https://www.loomsdk.com
> Ash: http://www.ashframework.org


## Usage

Usage is identical to the original ActionScript version except for listening, where delegates are used instead of events:

```
var nodeList:NodeList = engine.getNodeList(MyNode);
nodeList.nodeAdded += onNodeAdded;

private function onNodeAdded(node:Node):void
{
	// ...
}
```
