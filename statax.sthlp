{smcl}
{* *! version 1.0  01Oct2015}{...}
{* *! version 1.1  03Oct2015}{...}
{* *! version 1.2  09Oct2015}{...}
{right:Version 1.2 : October, 2015}

{marker title}{...}
{title:Title}

{phang}
{cmdab:statax} {hline 2} JavaScript syntax highlighter engine for Stata. It can 
append the Statax engine to an existing HTML file for and also, it can convert 
Stata do-file to HTML and highlights the syntax. 


{title:Author} 
        {p 8 8 2}E. F. Haghish{break} 
	Center for Medical Biometry and Medical Informatics{break}
	University of Freiburg, Germany{break} 
        {browse haghish@imbi.uni-freiburg.de}{break}
	{ul:{browse "http://www.haghish.com/statax":{it:http://haghish.com/statax}}}{break}


{marker syntax}{...}
{title:Syntax}

    convert do-file to HTML and highlight the syntax
	
	{cmdab:statax convert} using {it:{help filename}.do}, {opt replace style(name)} {opt css(filename)}
	

    create a new HTML file or append Statax JavaScript to an existing HTML file
	
	{cmdab:statax} using {it:{help filename}.html}, {opt replace append style(name)} {opt css(filename)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:Statax} is a JavaScript engine for hilighting Stata syntax in web-based 
documents. It can be used in online forum or any website or blog for highlighting
Stata syntax. The program acurately highlights Stata commands, {help functions}, string, 
local and global {help macros}, digits, comments, and braces. The engine can also 
highlight the operator signs, but since Stata does not highlight operators, the 
default CSS shows them in black color. 

{pstd}
Based on {browse "http://shjs.sourceforge.net/doc/gplv3.html":{bf:SHJS}} engine, 
a new JavaScript was written to highlight Stata syntax. In addition, a new JQuery 
program was written to highlight {help global} {help macro} syntax. The JavaScript 
file developed SHJS is called {it:sh_main.js} and the file developed by the 
author for Stata is named {it:stata.js}. The author also developed a CSS style 
sheet to create a syntax highlighter identical to Stata do-file editor, which is 
included in {it:Stata.css} file. 

{pstd}
Stata codes should be written in a {bf:<pre class="sh_stata">} tag, which is closed with {bf:</pre>}. For example:

{phang2}{cmd:<pre class="sh_stata"> }{p_end}
{phang2}{cmd:. sysuse auto, replace}{p_end}
{phang2}{cmd:. regress price mpg}{p_end}
{phang2}{cmd:</pre>}{p_end}


{title:Options}

{phang}{opt replace} replace the HTML file if already exists. {p_end}

{phang}{opt append} append the {bf:Statax} JavaScript engine to an existing HTML file.{p_end}

{phang}{cmdab:sty:le:(}{it:name}{cmd:)} change the style of the syntax hilghlighter. The available 
styles are
{bf:stata}, {bf:daring}, {bf:sunset}, and {bf:wrangler}. {bf:stata} is the 
default syntax highlighter style.{p_end}

{phang}{cmdab::css:(}{it:{help filename}}{cmd:)} link an external CSS file to allow 
users to change the appearence of the HTML file. All the styles 
relating to the document, syntax highlighter, and the dynamic table can be 
overruled using this option.{p_end}


{marker installation}{...}
{title:Installation}

{pstd}
For adding {bf:statax} to your website, visit {browse "http://www.haghish.com/statax":{it:http://haghish.com/statax}} 
to see the instalation guide and download the JavaScript files. 


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

