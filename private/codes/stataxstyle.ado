/*

			Statx Package : JavaScript Syntax Highlighter for Stata
					   
					   Developed by E. F. Haghish (2014)
			  Center for Medical Biometry and Medical Informatics
						University of Freiburg, Germany
						
						  haghish@imbi.uni-freiburg.de

		
                   The Statax Package comes with no warranty    	
				  
				  
	Syntax highlighter CSS
	
	
	Statax Versions
	==============================
	
	Statax 1.0  September, 2015
*/

		
program define stataxstyle

    version 11
    syntax [anything] , [STYle(name)] [css(str)]
	
	tempname canvas 
	capture file open `canvas' using "$statax" , write text append
			
	********************************************************************
	* Stata Style (default)
	********************************************************************
	if missing("`style'") | "`style'" == "stata" {
	local key #00008A	
	local str #800000
	local mac #008080
	local com #008000
	local pfn #0052FF
	local fun #0052FF
	local num #0333FF
	local sym black
	local bra #FF0182
	local bac 			// background
	local col			// font color
	}	
	
	if "`style'" == "daring" {
	local key #5E97F4	
	local str #73C935
	local mac #95A99F
	local com #CC8C3C
	local pfn #96A6C8
	local fun #96A6C8
	local num #FFDC33
	local sym #FFDC33
	local bra #906
	local bac #282828			//background
	local col #F4F4FF			// font color
	}
	
	if "`style'" == "sunset" {
	local key #294277	
	local str #DF0707
	local mac #646485
	local com #C3741C
	local pfn #466A97
	local fun #466A97
	local num #294277
	local sym #294277
	local bra #CD5C5C
	local bac #FFFCE5			//background
	local col 					// font color
	}
	
	if "`style'" == "wrangler" {
	local key #00F	
	local str #F39
	local mac #1281B7
	local com #555
	local pfn #00F
	local fun #00F
	local num #369
	local sym #A00
	local bra #906
	local bac 					//background
	local col 					// font color
	}
	
	
	file write `canvas' _n(2) 												///
	"<!-- " _n 																///
	"Stata Syntax Highlighter Style Sheet " _n                              ///
	"Developed by E. F. Haghish http://www.haghish.com/" _n   				///    									
	"Center for Medical Biometry and Medical Informatics" _n 				///
	"University of Freiburg, Germany" _n 									///
	"haghish@imbi.uni-freiburg.de" _n										///
	"for documentation visit http://www.haghish.com/statax"	_n				///
	"-->" _n(3)																///
	`"<style type="text/css">"' _n 											///
	_skip(4) "pre.sh_sourceCode .sh_keyword          { color: `key'; }     /* Stata Commands        */" _n  	///        
	_skip(4) "pre.sh_sourceCode .sh_string           { color: `str'; }     /* strings               */" _n  	///          
	_skip(4) "pre.sh_sourceCode .sh_macro            { color: `mac'; }     /* local & global macros */" _n  	///          
	_skip(4) "pre.sh_sourceCode .sh_string .sh_macro { color: `str'; }     /* macro in string       */" _n  	///        
	_skip(4) "pre.sh_sourceCode .sh_comment          { color: `com'; }     /* Comment               */" _n  	///       
	_skip(4) "pre.sh_sourceCode .sh_predef_func      { color: `pfn';    }     /* Stata Functions       */" _n    /// 
	_skip(4) "pre.sh_sourceCode .sh_function         { color: `fun';    }     /* Any Function()        */" _n  	///                      
	_skip(4) "pre.sh_sourceCode .sh_number           { color: `num'; }     /* Numbers               */" _n  	///    
	_skip(4) "pre.sh_sourceCode .sh_symbol           { color: `sym';   }     /* Operators and signs   */" _n 	///                    
	_skip(4) "pre.sh_sourceCode .sh_cbracket         { color: `bra'; }     /* Braces                */" _n  	///    
	_skip(4) "pre.sh_stata{font-family: 'menlo-regular', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', 'sans-serif','Trebuchet MS';background-color:`bac';color:`col'}" _n 	///                          
	"</style>" _n(4)
		
	****************************************************************************
	* Importing External style
	****************************************************************************
	if !missing("`css'") file write `canvas' _n(2) 								///
	"<!--     Adding External CSS     -->"	_n									///	
	`"<link rel="stylesheet" type="text/css" href="`css'">"' _n(2)
	
	
	file close `canvas'
end
