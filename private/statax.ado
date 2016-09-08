/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 1.4
Title: statax
Description: __JavaScript__ and __LaTeX__ syntax highlighter for Stata. The 
command converts do-files to HTML or LaTeX and applies the syntax highlighter, 
to provide an example of the rendered document. 
add [hyperlink](http://www.haghish.com/markdoc) 
----------------------------------------------------- DO NOT EDIT THIS LINE ***/


/***
{marker syntax}{...}
{title:Syntax}

    convert do-file to HTML and highlight the syntax
	
	{cmdab:statax convert} using {it:{help filename}.do}, {opt replace style(name)} {opt css(filename)}
	

    create a new HTML file or append Statax JavaScript to an existing HTML file
	
	{cmdab:statax} using {it:{help filename}.html}, {opt replace append style(name)} {opt css(filename)}
	

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt rep:lace}}replace the HTML file if already exists{p_end}

{synopt :{opt append}}append the {bf:Statax} JavaScript engine to an existing HTML file{p_end}

{synopt :{opt style(name)}}change the style of the syntax hilghlighter. The available 
styles are
{bf:stata}, {bf:daring}, {bf:sunset}, and {bf:wrangler}. {bf:stata} is the 
default syntax highlighter style{p_end}

{synopt :{opt css(filename)}}link an external CSS file to allow 
users to change the appearence of the HTML file. All the styles 
relating to the document, syntax highlighter, and the dynamic table can be 
overruled using this option {p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
Statax includes 2 engines for highlighting Stata code in HTML and LaTeX documents.

{pstd}
Based on {browse "http://shjs.sourceforge.net/doc/gplv3.html":SHJS} engine, 
a new JavaScript was written to highlight Stata syntax. In addition, a new JQuery 
program was written to highlight {help global} {help macro} syntax. The JavaScript 
file developed SHJS is called {it:sh_main.js} and the file developed by the 
author for Stata is named {it:stata.js}. The author also developed a CSS style 
sheet to create a syntax highlighter identical to Stata do-file editor, which is 
included in {it:Stata.css} file. The JavaScript engine 
can be used in HTML files, online forums, or any website or blog for highlighting
Stata syntax. The program acurately highlights Stata commands, {help functions}, string, 
local and global {help macros}, digits, comments, and braces. The engine can also 
highlight the operator signs, but since Stata does not highlight operators, the 
default CSS shows them in black color. 


{pstd}
The LaTeX syntax highlighter was developed based on the 
{browse "https://www.ctan.org/pkg/listings?lang=en":listings} package which is used for typesetting 
source code in the document. In order to highlight Stata syntax in LaTeX document, you should 
{browse "https://raw.githubusercontent.com/haghish/Statax/master/Statax.tex":append the content of Statax.tex} 
to the heading of your LaTeX document. Alternatively, you can {bf:\include{c -(}path/to/statax.tex{c )-}} the 
{browse "https://raw.githubusercontent.com/haghish/Statax/master/Statax.tex":Statax.tex} file in the heading of 
your LaTeX document. Next, you can highlight Stata syntax by placing Stata commands between 
{bf:\begin{c -(}statax{c )-}} and {bf:\end{c -(}statax{c )-}}


{marker installation}{...}
{title:Installation}

{pstd}
For adding {bf:statax.js} JavaScript to your website or HTML files or the {bf:statax.tex} to your 
LaTeX document, visit {browse "http://www.haghish.com/statax":{it:http://haghish.com/statax}} 
to see the full instalation guide. 


{marker example}{...}
{title:Example of interactive use}

{pstd}
You would like to get a taste of the Statax syntax highlighter? run an exanple 
by specifying a name HTML filename 

{phang2}{cmd:. statax using example.html, replace}{p_end}

{pstd}
You have a do-file and you would like to convert it to HTML and highlight the 
syntax. It will create an HTML file with the same name as the do-file

{phang2}{cmd:. statax convert using} {help filename}.do, {opt replace}‚


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

_This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/)_ 
***/



program define statax
    version 11
	
	syntax [anything] using/ , 	[STYle(name)] [Format(name)]						///
	[append|replace] [css(str)] 										
	
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

