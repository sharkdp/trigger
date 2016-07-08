# trigger

``` bash
Usage: trigger COMMAND FILE1 [FILE2...]
```

trigger runs the given *COMMAND* every time one of the *FILE*s is changed.

In the COMMAND string, `#1`, `#2`, .. can be used as synonyms for the *FILE*names.
The helper `tg COMMAND FILE1 ...` is a shortcut for `trigger 'COMMAND #1' FILE1 ...`.

![Example usage](http://i.imgur.com/xlpR376.gif)

## Examples

### Make

Run `make` every time one of the source files changes:

```
trigger make src/*.cpp src/*.h
```

### Python

Run `python main.py` every time either `main.py` or `config.py` changes:

``` bash
trigger 'python #1' main.py config.py
```

By using the `tg` helper command, this can be shortened to:

``` bash
tg python main.py config.py
```

### Markdown to PDF

Convert a Markdown document to PDF every time it is changed. Combine this with
an auto-reloading PDF-viewer (e.g. okular) to get a live preview:

``` bash
tg 'pandoc -t latex -o README.pdf' README.md
```

### Less to CSS

Convert a LESS file to CSS:

``` bash
trigger 'lessc #1 > main.css' main.less
```


## Requirements

trigger is just a simple wrapper around `inotifywait`. It should be available
for most Linux distributions (the package is typically called `inotify-tools`).


## Installation

Keeping in mind that, in principle, you should not copy-and-paste into your
shell, something like this should work:

``` bash
git clone https://github.com/sharkdp/trigger ~/.trigger

echo 'export PATH="$PATH:$HOME/.trigger"' >> .bashrc
```
