{smcl}
{right:version 1.7}
{title:Title}

{phang}
{cmd:statax} {hline 2} {bf:JavaScript} and {bf:LaTeX} syntax highlighter for Stata. For more information, see the  {browse "http://www.haghish.com/statax":homepage} and 
 the package  {browse "https://github.com/haghish/Statax":manual on GitHub} 
 

{title:Description}

{p 4 4 2}
Statax package includes 2 engines for highlighting Stata code in HTML and LaTeX 
documents. The package hosts the JavaScript engine named {bf:Statax.js} and its 
required other JavaScript programs as well as the LaTeX engine named 
{bf:Statax.tex}. In addition, the package includes three additional syntax 
highlighter themes which are {bf:wrandler}, {bf:daring}, and {bf:sunset}. For the 
JavaScript engine, these themes have {bf:.css} file sufix and for LaTeX they 
have {bf:.tex} suffix. 

{p 4 4 2}
After installing the package, the engines and the optional themes are installed 
in the {help sysdir:PLUS directory} and thus you can use Stata to obtain the 
path to each file. For example, to find the path to LaTeX engine and the optional 
theme {bf:daring.tex} type:

    . findfile statax.tex, path(PLUS)
    . findfile daring.tex, path(PLUS)

{p 4 4 2}
The syntax highlighter engine is quite simple to include in LaTeX documents, 
beamer slides, HTML documents, blogs, and websites. The package also includes 
a quick installation that works by adding a single command in the HTML or LaTeX 
document. For tutorials and examples, visit 
{browse "https://github.com/haghish/Statax":Statax manual on GitHub}. 


{title:Author}

{p 4 4 2}
{bf:E. F. Haghish}       {break}
Center for Medical Biometry and Medical Informatics       {break}
University of Freiburg, Germany       {break}
{it:and}          {break}
Department of Mathematics and Computer Science         {break}
University of Southern Denmark       {break}
haghish@imbi.uni-freiburg.de       {break}

{p 4 4 2}
{browse "www.haghish.com/statax":Statax Homepage}           {break}
Statax Updates on  {browse "http://www.twitter.com/Haghish":Twitter}      {break}

    {hline}

{p 4 4 2}
This help file was dynamically produced by  {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}

