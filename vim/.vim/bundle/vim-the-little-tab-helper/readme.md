# The little tab helper

This is a plugin for Vim written for personal use that changes how file names are displayed in the tabs by substituting `index` files with the symbol `➔` to save space.

The original use case for this is for module and components following the convention

```
Component/index.js => Component/➔js
Component/index.less => Component/➔less
```

While doing so redefines also the tabline
