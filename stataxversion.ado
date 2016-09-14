/*

			Statx Package : JavaScript Syntax Highlighter for Stata
					   
					   Developed by E. F. Haghish (2014)
			  Center for Medical Biometry and Medical Informatics
						University of Freiburg, Germany
						
						  haghish@imbi.uni-freiburg.de

		
                   The Statax Package comes with no warranty    	
				  
				  
	DESCRIPTION
	==============================
	This program checks the current version of Statax on the users' machine
	
	
	Versions
	==============================
	Statax version 1.0  September, 2015
	Statax version 1.1  October, 2015
	Statax version 1.2  October, 2015
*/


program define stataxversion
    version 11
	
	global stataxversion 1.2
	
	// make sure that Stata repeats the notification once per lunch
	if "$theneweststataxversion" == "" {		
		cap qui do "http://www.haghish.com/packages/update.do"
	}
	
	if "$theneweststataxversion" > "$stataxversion" {
				
		di _n(4)
				
		di "  _   _           _       _                __  " _n 				///
		" | | | |_ __   __| | __ _| |_ ___       _  \ \ " _n 					///
		" | | | | '_ \ / _` |/ _` | __/ _ \     (_)  | |" _n 					///
		" | |_| | |_) | (_| | (_| | ||  __/      _   | |" _n 					///
		"  \___/| .__/ \__,_|\__,_|\__\___|     (_)  | |" _n 					///
		"       |_|                                 /_/ "  _n 					///


		di as text "{p}{bf: Statax} has a new update available! Click on " 		///
		`"{ul:{bf:{stata "adoupdate statax, update":Update Statax Now}}} "' 	///
		"or alternatively type {ul: {bf: adoupdate statax, update}} to update "	///
		"the package. For more information regarding the new features of " 		///
		`"Statax, visit {browse "http://www.haghish.com/statax":{it:http://haghish.com/statax}}{smcl}"'
					
	}
												
end


