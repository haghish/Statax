# Statax : JavaScript and LaTeX syntax highlighter engine for Stata

<a href="http://haghish.com/statax"><img src="./Statax2.png" align="left" width="140" hspace="10" vspace="6"></a>

Statax is a syntax highlighter for Stata. The program was developed for [Weaver](http://haghish.com/weaver)
and [MarkDoc](http://haghish.com/markdoc) packages in order to highlight the Stata code in dynamic documents 
and dynamic slides. 

The __JavaScript__ engine is hosted on my website and can be easily added to any webpage. 
See [Statax Homepage](http://www.haghish.com/statax/statax.php) for details. in brief, 
all you have to do to load the javaScript in your HTML document is adding the following code:

	<script type="text/javascript" src='http://haghish.com/statax/Statax.js'></script>

And writing your Stata code in:

	<pre class="sh_stata">
	. Stata code
	. Stata code
	...
	</pre>


The __LaTeX__ syntax highlighter is even easier to implement. All you need to do is loading the __Statax.tex__ in the header of your latex document, before you `\begin{document}` as shown below:

	\input{Statax}

Once the Statax file is loaded in the header, You can call the __statax__ environment to highlight the Stata syntax.
For example:

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

	


 

        
Author
------
  **E. F. Haghish**  
  Center for Medical Biometry and Medical Informatics
  University of Freiburg, Germany      
  _haghish@imbi.uni-freiburg.de_     
  _http://www.haghish.com/weaver_  
  _[@Haghish](https://twitter.com/Haghish)_   
  
Installation
------------

The __Statax__ releases are also hosted on SSC server. So you can download the latest release as follows:

    ssc install statax
    
You can also directly download __Statax__ from GitHub which includes the latest beta version (unreleased). The `force` 
option ensures that you _reinstall_ the package, even if the release date is not yet changed, and thus, must be specified. 
  
    net install statax, force  from("https://raw.githubusercontent.com/haghish/statax/master/")
    
The complete guide for installing them is provided in the MarkDoc help file and also, 
[__Statax Homepage__ ](http://www.haghish.com/statax/statax.php)
    





