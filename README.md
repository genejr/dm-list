digilord:list
=======

A list item template that allows one to build a series of lists in a consistent manner.

## Why?
In designing my application I had an administration view that was a series of tabs.  Each tab was identical in structure to the others visually.  The only real changes were the columns displayed and the form for data entry and editing.  After my second round of changes to the way the list worked I decided it was time to make a re-usable template and associated methods.  digilord:list was born.

An example project is located in the example folder in the project repository.

## Setup


### Field Types
__All examples below are in CoffeeScript. Why? Because it's what I use.__

All field types have a few base options available.

 - required
 - label
 - value
 - size - Required and must be between 1 and 12. This corresponds to the 12 columns in a bootstrap layout.
 
---

#### select
 - options - This is for the values in the select box. The data can come from an array or collection.
 - display_attribute - Inside the options that come from a collection use this attribute name to determine what is displayed.
 
Example with an Array:

```
	month:
        required: true
        inputType: 'select'
        options: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul','Aug','Sep', 'Nov', 'Dec']
        size: 6
```

Example with a collection:

```
	countries:
        required: true
        inputType: 'select'
        options: Countries.find({})
        display_attribute: 'name'        
        size: 6
```

#### checkbox
A checkbox receives its label from the field name.

```
	blue:
        required: true
        inputType: 'checkbox'
        size: 2
```

#### hrule
 - cssClass - You should know what to put here :)

A horizontal rule added to the interface. You can name the field anything. 

```
	hrule:
		inputType: 'hrule'
		size: 6
		cssClass: 'Anything'
```



---
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

[![endorse](https://api.coderwall.com/digilord/endorsecount.png)](https://coderwall.com/digilord)

