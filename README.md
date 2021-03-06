> __Cite__: Haghish, E. F. (2019). On the importance of syntax coloring for teaching statistics. The Stata Journal, 19(1), 83-86.

# Statax : JavaScript and LaTeX syntax highlighter engine for Stata

<a href="http://haghish.com/statax"><img src="./images/Statax.png" align="left" width="140" hspace="10" vspace="6"></a>

[__`statax`__](http://haghish.com/statax) is a syntax highlighter for Stata. The packages includes two separate engines (JavaScript and LaTeX) to highlight Stata commands in HTML- and LaTeX-based documents. A plenty of Stata package produce documents or presentation slides in HTML and LaTeX and the engines can simply be wired to these packages to highlight the syntax of Stata commands. For example, 
[`weaver`](http://haghish.com/weaver) and [MarkDoc](http://haghish.com/markdoc) packages require `statax` for syntax highlighting. 
Long story short, syntax highlighters might improve code comprehension and encourage learners to pay more attention to the 
code. 

Installation
------------

You can directly download __Statax__ from GitHub. Check the [release page](https://github.com/haghish/Statax/releases) for the curent version and new features. 

<!--
```js
net install statax, from("https://raw.githubusercontent.com/haghish/statax/master/")
```
-->

The [__`github package`__](https://github.com/haghish/github) is the only recommended way for installing **`statax`**. Once [__`github`__](https://github.com/haghish/github) is installed, type any of the following commands:

```js
github install haghish/statax
```
    
The complete guide for installing them is provided in the MarkDoc help file and also, 
[__Statax Homepage__ ](http://www.haghish.com/statax/statax.php)


Description
------------

`statax` can acurately distinguish several different elements in Stata syntax such as:

1. commands
2. functions
3. local and global macros
4. strings
4. numbers
5. operators
6. comments
7. curly brackets


The __JavaScript__ engine is hosted on my website and can be easily added to any webpage. 
See [Statax Homepage](http://www.haghish.com/statax/statax.php) for details. in brief, 
all you have to do to load the javaScript in your HTML document is adding the following code:

```js
<script type="text/javascript" src='http://haghish.com/statax/Statax.js'></script>
```

And writing your Stata code in:

```html
<pre class="sh_stata">
	. Stata code
	. Stata code
	...
</pre>
```


The __LaTeX__ syntax highlighter is even easier to implement. All you need to do is loading the __Statax.tex__ in the header of your latex document, before you `\begin{document}` as shown below:

```latex
\input{Statax}
```

Once the Statax file is loaded in the header, You can call the __statax__ environment to highlight the Stata syntax.
For example:

```latex
\begin{statax}
	
	// JavaScript Syntax Highlighter for Stata
	
	quietly erase "`This' $Example"
	noisily do `Something'
	forvalues num = 5/13 {
	count if vari`num' > 10 //this is a comment
	scalar 5 = 2 * 10 
	generate x = runiform()
	}
	
	/*
	E. F. Haghish
	Center for Medical Biometry and Medical Informatics
	Unersity of Freiburg, Germany
	*/

\end{statax}
```
	
Customization
-------------

`statax` can be easily customized. To do that, you need to include a theme file (Tex or CSS) to redefine the default syntax highlighter. The package includes three additional themes to provide examples of theme customization. 

### HTML documents

To customize the HTML document, source the CSS after sourcing the JavaScript file in the header. For example, you can add the `Sunset.css` theme from the web as follows:

#### Sunset theme

```js
<script type="text/javascript" src='http://haghish.com/statax/Statax.js'></script>
<link rel="stylesheet" type="text/css" href="http://haghish.com/statax/CSS/Sunset.css">
```

<img src="./images/Sunset.png" align="center" width="450">

#### Daring theme

```js
<script type="text/javascript" src='http://haghish.com/statax/Statax.js'></script>
<link rel="stylesheet" type="text/css" href="http://haghish.com/statax/CSS/Daring.css">
```

<img src="./images/Daring.png" align="center" width="450">


#### Wrangler theme

```js
<script type="text/javascript" src='http://haghish.com/statax/Statax.js'></script>
<link rel="stylesheet" type="text/css" href="http://haghish.com/statax/CSS/Wrangler.css">
```

<img src="./images/Wrangler.png" align="center" width="450">


Complete example files
======================

A minimalistic _LaTeX_ file is shown below with a code section that highlights Stata syntax:

```tex
\documentclass[12pt]{article}
\include{Statax}
\begin{document}
  \section{Statax Syntax Highlighter}
  \begin{statax}
    // Stata code or comment ...
  \end{statax}
\end{document}
```

and the code below shows a simple HTML file that can highlight Stata code:

```html
<html>
  <head>
    <script src='http://haghish.com/statax/Statax.js'></script>
  </head>
  <body>
    <pre class="sh_stata" >
      // place Stata code or commnents here ...
    </pre>
  </body>
</html>
```




Updating Statax with new Stata commands
=======================================

The `statax` engines can be updated to recognize new Stata commands and functions. The _LaTeX_ and JavaScript engines both include separate word lists for Stata commands and functions. These word lists are defined in `Statax.tex` and `StataxSource.js` files respectively. The files include commented sections indicating where and how to add new Stata commands or functions. 

Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics
  University of Freiburg, Germany      
  _haghish@imbi.uni-freiburg.de_     
  _http://www.haghish.com/weaver_  
  _[@Haghish](https://twitter.com/Haghish)_   
  

    





