/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.4
Title: statax
Description: __JavaScript__ and __LaTeX__ syntax highlighter for Stata. 
For more information, see the [homepage](http://www.haghish.com/statax) and 
the package [manual on GitHub](https://github.com/haghish/Statax) 
----------------------------------------------------- DO NOT EDIT THIS LINE ***/


/***
Description
===========

Statax package includes 2 engines for highlighting Stata code in HTML and LaTeX 
documents. The package hosts the JavaScript engine named __Statax.js__ and its 
required other JavaScript programs as well as the LaTeX engine named 
__Statax.tex__. In addition, the package includes three additional syntax 
highlighter themes which are __wrandler__, __daring__, and __sunset__. For the 
JavaScript engine, these themes have __.css__ file sufix and for LaTeX they 
have __.tex__ suffix. 

After installing the package, the engines and the optional themes are installed 
in the {help sysdir:PLUS directory} and thus you can use Stata to obtain the 
path to each file. For example, to find the path to LaTeX engine and the optional 
theme __daring.tex__ type:

    . findfile statax.tex, path(PLUS)
    . findfile daring.tex, path(PLUS)

The syntax highlighter engine is quite simple to include in LaTeX documents, 
beamer slides, HTML documents, blogs, and websites. The package also includes 
a quick installation that works by adding a single command in the HTML or LaTeX 
document. For tutorials and examples, visit 
[Statax manual on GitHub](https://github.com/haghish/Statax). 

Author
======

__E. F. Haghish__     
Center for Medical Biometry and Medical Informatics     
University of Freiburg, Germany     
_and_        
Department of Mathematics and Computer Science       
University of Southern Denmark     
haghish@imbi.uni-freiburg.de     
      
[Statax Homepage](www.haghish.com/statax)         
Statax Updates on [Twitter](http://www.twitter.com/Haghish)    

- - -

This help file was dynamically produced by [MarkDoc Literate Programming package](http://www.haghish.com/markdoc/)
***/



markdoc statax.ado, export(sthlp) replace
