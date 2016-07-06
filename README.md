# trigger

## Usage

``` bash
trigger COMMAND FILE1 [FILE2...]
```

Runs the given `COMMAND` every time one of the `FILE`s is changed.

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
an auto-reloading PDF-viewer (e.g. okular) to get a live preview.

``` bash
trigger 'pandoc #1 -t latex -o README.pdf' README.md
```

### Less to CSS

Convert a LESS file to CSS

``` bash
trigger 'lessc #1 > main.css' main.less
```

## Installation

Put the two scripts `trigger` and `tg` somewhere on your `PATH`.
