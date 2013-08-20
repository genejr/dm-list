dm-list
=======

A list item template that allows one to build a series of lists in a consistent manner.

## Why?
In designing my application I had an administration view that was a series of tabs.  Each tab was identical in structure to the others visually.  The only real changes were the columns displayed and the form for data entry and editing.  After my second rund of changes to the way the list worked I decided it was time to make a re-usable temmplate and associated methods.  dm-list was born.

### Components
Each of the following sections details a component and how it's used.

#### Template
The template itself is not rendered in the same way that most templates in Meteor are rendered.  This one is called via `Template.list(data)`.

`data` is an object containing the description of the list.



## License
The MIT License (MIT)

Copyright (c) 2013 D. Allen Morrigan

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

