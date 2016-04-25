/*

			Statx Package : JavaScript Syntax Highlighter for Stata
					   
					   Developed by E. F. Haghish (2014)
			  Center for Medical Biometry and Medical Informatics
						University of Freiburg, Germany
						
						  haghish@imbi.uni-freiburg.de

		
                   The Statax Package comes with no warranty    	
				  
				  
	DESCRIPTION
	==============================
	JavaScript Statax highlighter for Stata syntax
	
	
	Versions
	==============================
	Statax version 1.0  September, 2015
	Statax version 1.1  October, 2015
	Statax version 1.2  October, 2015
*/


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
