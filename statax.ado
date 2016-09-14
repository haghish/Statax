/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.7
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


program define statax
    version 11
	
	syntax [anything] using/ , 													///
	[append|replace] [css(str)] [STYle(name)] 										
	
	****************************************************************************
	* Syntax Processing
	****************************************************************************
	if !missing("`replace'") & !missing("`append'") {
		di as err "invalid syntax"
		exit 198
	}
	
	if length("`using'") >= 5 & missing("`anything'") {
		if substr("`using'",-5,.) != ".html" & substr("`using'",-5,.) != "xhtml"  ///
		& substr("`using'",-4,.) != ".htm" {
			local jump 1
		}
	}
	
	// file format
	if !missing("`jump'") & missing("`anything'") | length("`using'") < 5 		///
	& missing("`anything'") {
		di as txt _n(2) "{hline}"
			di as error "{bf:Warning}" 
			di as txt "{p}The specified file does not have {bf:html}, {bf:htm}" ///
			", or {bf:xhtml} file suffix" _n 
			di as txt "{hline}{smcl}"	_n
	}
	
	// style names
	if !missing("`style'") & "`style'" != "stata" & "`style'" != "daring" 		///
	& "`style'" != "sunset" & "`style'" != "wrangler"  {
		di as err "{bf:`style'} is invalid style"
		exit 198
	}
	
	if !missing("`anything'") {
		if "`anything'" != "convert" {
			di as err "invalid syntax"
			exit 198
		}
		
		// if append is used, return an error
		if !missing("`append'") {
			di as err "{bf:append} option is not allowed"
			exit 198
		}
		
		//define the html file
		global statax "`using'.html"
	}
	
	if missing("`anything'") global statax "`using'"

	****************************************************************************
	* Creating the file
	****************************************************************************
	tempname canvas 
	qui file open `canvas' using "$statax" , write text `replace' `append'
	
	if missing("`append'") {
		file write `canvas' `"<!doctype html>"' _n								///
		"<!-- Statax JavaScript Syntaxhighlighter is developed by "				///
		"E. F. Haghish (http://www.haghish.com)  -->" _n						///
		"<!-- The JavaScript and CSS files can be downloaded from"				///
		" http://www.haghish.com/statax           -->" _n						///
		"<!-- based on a program written by SHJS. License: "					///
		"http://shjs.sourceforge.net/doc/gplv3.html     -->" _n(3)				///
		`"<html>"' _n															///
		"<head>" _n																///
		`"<meta charset="UTF-8">"' _n 											///
		`"<meta name="description" content="Statax syntax highlighter. "' 		///
		`"Learn more on http://www.haghish.com">"' _n 							///
		`"<meta name="author" content="E. F. Haghish">"' _n(2)
	}
	
	****************************************************************************
	* Appending CSS style sheet
	****************************************************************************
	file close `canvas'
	stataxstyle , style(`style') css("`css'") 
	capture file open `canvas' using "$statax" , write text append
	
	****************************************************************************
	* Main JavaScript engine developed by SHJS
	* Stata JavaScript Syntaxhighlighter developed by E. F. Haghish
	****************************************************************************
	file close `canvas'
	stataxmain										// developed by SHJS 	
	stataxsyn										// developed by E. F. Haghish
	
	capture file open `canvas' using "$statax" , write text append

	
	****************************************************************************
	* Write the example
	****************************************************************************
	if missing("`anything'") { 
		if missing("`append'") {
			file write `canvas' "</head>" _n(2) 								///
			///`"<body onload="sh_highlightDocument()">"' _n(10)				///	
			`"<body>"' _n(10)													///
			`"<pre class="sh_stata" >"' _n										///
			"* Introducing Statax package!" _n									///
			"// JavaScript Syntax Highlighter for Stata" _n(2)					///
			`"quietly erase "\`This' \$Example""' _n							///
			"noisily do \`Something' \$Awesome" _n								///
			"forvalues num = 5/13 {" _n											///
			_skip(4) "count if vari\`num' > 10" _n								///
			_skip(4) "generate x`num' = runiform()" _n							///
			"}" _n(2)															///
			"/*" _n																///
			"E. F. Haghish" _n 													///
			"Center for Medical Biometry and Medical Informatics" _n			///
			"Unersity of Freiburg, Germany" _n 									///
			"*/" _n																///
			"</pre>" _n(2)														///
			`"<p style="background:#FFFFCC;"> For documentation and details visit"' ///
			`" <a href="http://www.haghish.com/statax">"'						///
			"http://www.haghish.com/statax</a><br>"								///
			`"Twitter updates <a href="https://twitter.com/Haghish">"'			///
			`"@Haghish</a></p>"' _n(10)											///
			"</body>" _n														///
			"</html>"_n(4)
		}
	}
		
	****************************************************************************
	* Convert do file
	****************************************************************************
	if !missing("`anything'") { 
		tempname hitch  
		file open `hitch' using `"`using'"', read
		file write `canvas' "</head>" _n(2) 									///
		///`"<body onload="sh_highlightDocument()">"' _n(10)					///
		`"<body>"' _n(10)														///
		`"<pre class="sh_stata" >"' _n											

		file read `hitch' line
		while r(eof) == 0 {
			
			file write `canvas' `"`macval(line)'"' _n			
			file read `hitch' line	
		}
		
		file write `canvas' _n `"</pre>"' _n
		file close `hitch'											
			
	}
	
	****************************************************************************
	* Stata Output
	****************************************************************************	
	
	if missing("`append'") {
		di as txt _n(3)                                           					///
		"{hline}" _n                                        						///
		`"{bf:{browse "http://www.haghish.com/statax":Statax}} "'					///
		`"created {it:{bf:{browse `"${statax}"'}}} "' _n  	
	}	
		
	file close `canvas'
	
	****************************************************************************
	* Check for updates
	****************************************************************************
	stataxversion
	
	
	// remove macros
	macro drop statax								// drop the macro
	cap macro drop weaverstatax						// This Macro communicates with Weaver	
										
end
