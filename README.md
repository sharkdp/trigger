# trigger

``` bash
Usage: trigger COMMAND FILE1 [FILE2...]
```

trigger runs the given *COMMAND* every time one of the *FILE*s is changed.

In the COMMAND string, `#1`, `#2`, .. can be used as synonyms for FILE1, FILE2, ..


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

By using the `tg` helper command (`tg CMD FILE1..` is equivalent to `trigger 'CMD #1' FILE1 ..`), this can be shortened to:

``` bash
tg python main.py config.py
```

### Markdown to PDF

Convert a Markdown document to PDF every time it is changed. Combine this with
an auto-reloading PDF-viewer (e.g. okular) to get a live preview:

``` bash
trigger 'pandoc #1 -t latex -o README.pdf' README.md
```

### Less to CSS

Convert a LESS file to CSS:

``` bash
trigger 'lessc #1 > main.css' main.less
```

## Installation

Simply put the two scripts `trigger` and `tg` somewhere on your `PATH`.

Keeping in mind that, in principle, you should not copy-and-paste into your
shell, something like this should work:
``` bash
mkdir ~/.trigger
cd ~/.trigger

wget https://raw.githubusercontent.com/sharkdp/trigger/master/trigger
wget https://raw.githubusercontent.com/sharkdp/trigger/master/tg

chmod +x tg trigger
echo 'export PATH="$PATH:$HOME/.trigger"' >> .bashrc
```
