# Dummy box

Vagrant providers each require a custom provider-specific box format. This folder
contains a "dummy" box that allows you to use the plugin without the need to create
a custom base box.

To turn this into a "box", run:

```
tar cvzf dummy.box ./metadata.json
```
