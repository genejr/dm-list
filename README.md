dm-list
=======

A list item template that allows one to build a series of lists in a consistent manner.

## Why?
In designing my application I had an administration view that was a series of tabs.  Each tab was identical in structure to the others visually.  The only real changes were the columns displayed and the form for data entry and editing.  After my second round of changes to the way the list worked I decided it was time to make a re-usable template and associated methods.  dm-list was born.

An example project is located at https://github.com/digilord/dm-person.

## Setup
A package that uses dm-list needs to have a few things setup in order to work properly.

1. Mesosphere installed
2. dm-list installed

Mesosphere is used as a form validation tool. I worked with the author to extend Mesosphere to allow for the addition of input type specifiers. This additional sugar allowed for the Mesosphere fields object to be used to create the forms used by dm-list.

### Mesosphere Definition Example

```

```



## License
The MIT License (MIT)

Copyright &copy; 2014 D. Allen Morrigan

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Donating
By donating you are supporting this package and its developer so that he may continue to bring you updates to this and other software he maintains.

[![Support us via Gittip][gittip-badge]][digilord]

[gittip-badge]: https://rawgithub.com/digilord/gittip-badge/master/dist/gittip.png
[digilord]: https://www.gittip.com/digilord/

