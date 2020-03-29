# trigger

``` bash
Usage: trigger COMMAND [FILE...]
```

trigger runs the given *COMMAND* every time one of the *FILE*s is changed.
If no *FILE* argument is given, trigger watches everything in the current
directory, recursively.

In the *COMMAND* string, `#1`, `#2`, .. can be used as synonyms for the
*FILE*names. The helper `tg COMMAND FILE ...` is a shortcut for
`trigger 'COMMAND #1' FILE ...`.

![Example usage](http://i.imgur.com/xlpR376.gif)

## Examples

### Make

Run `make` every time one of the files in the current directory changes:

```
trigger make
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

### Interrupt mode

If `trigger` is called with the `-i` (or `--interrupt`) option, it will kill
running subprocesses whenever a file changes:
``` bash
trigger -i longRunningCommand input.dat
```


## Requirements

### Linux
trigger is just a simple wrapper around `inotifywait`. It should be available
for most Linux distributions (the package is typically called `inotify-tools`).

### Mac

trigger uses `fswatch` when running on a Mac. 
You can install it with brew: `brew install fswatch`

## Installation

Keeping in mind that, in principle, you should not copy-and-paste into your
shell, something like this should work:

``` bash
git clone https://github.com/sharkdp/trigger ~/.trigger

echo 'export PATH="$PATH:$HOME/.trigger"' >> .bashrc
```

## Related projects

Also have a look at these projects, to see if they fit your needs better:

- [http://entrproject.org/](http://entrproject.org/) - more features, slightly more complicated syntax
- [https://github.com/joh/when-changed](https://github.com/joh/when-changed) - different syntax, requires python and watchdog
- [https://facebook.github.io/watchman/](https://facebook.github.io/watchman/) - much more powerful but more complicated syntax.
- [http://inotify.aiken.cz/?section=incron&page=about](http://inotify.aiken.cz/?section=incron&page=about) - more difficult to setup up
