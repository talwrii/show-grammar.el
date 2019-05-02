# show-grammar.el

Syntax highlighting for English language writing.

# Attribution

Sacha Chua's [artbollocks-mode](https://github.com/sachac/artbollocks-mode) was used as a scaffold for this project enabling and disabling multiple font-lock settings.

# Introduction

This project is very much experimental. The idea is that when *writing* and editing (rather than reading) some sort of "syntax highlighting" of grammatical features can improve one's writing both in terms of catching mistakes early and make the writing choices one is making more apparent. 

When coding syntax highlighting can act as a sort of "sixth sense" making one aware of things you might not otherwise we aware of. Over time one notices when the syntax highlighter does not behave as expected causing one to detect errors and choices it is hoped that a similar sort of process can take place when writing and editing. 

# Installation

Add this to your load-path or use [straight](https://github.com/raxod502/straight.el) by adding the following to your `init.el`

```(straight-use-package '(show-grammar :type git :host github :repo "talwrii/show-grammar.el"))```

# Usage

```
(require 'show-grammar)
```

Load show-grammar-mode in text-mode by default - or use it in a one off manner with.

```
(add-hook 'text-mode-hook 'show-grammar-mode)
```

```M-x show-grammar-mode```

The default mode is quite "colorful". You might prefer to look at different types of highlighting for different stages of proof reading using `show-grammar-only-this`, `show-grammar-hide-this`, `show-grammar-everything.

