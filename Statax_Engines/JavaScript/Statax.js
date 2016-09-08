 /*
    Developed by E. F. Haghish http://www.haghish.com/
    Center for Medical Biometry and Medical Informatics
    University of Freiburg, Germany
    haghish@imbi.uni-freiburg.de
    for documentation visit http://www.haghish.com/statax

    This file loads sh_main.js, stataxsource.js, and Statax.css files and also 
    highlight syntax of Global Macros in Stata. 
 */ 



//********************************************************
//* LOAD JQuery
//********************************************************
function include(filename, onload) {
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.src = filename;
    script.type = 'text/javascript';
    script.onload = script.onreadystatechange = function() {
        if (script.readyState) {
            if (script.readyState === 'complete' || script.readyState === 'loaded') {
                script.onreadystatechange = null;                                                  
                onload();
            }
        } 
        else {
            onload();          
        }
    };
    head.appendChild(script);
}

include('https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js', function() {
    $(document).ready(function() {

        //********************************************************
        //* JQuery script for highlighting Stata Global Macro
        //********************************************************
        $(document).ready(function(){
            $("pre.sh_stata").html(function(_, html){
                return html.replace(/(\$\w+)/g,'<span class="sh_macro">$1</span>');
            });
        });
    });
});
//********************************************************
//* LOAD Statax.js
//********************************************************

var imported = document.createElement('script');
imported.src = 'StataxSource.js';
document.head.appendChild(imported);

var imported2 = document.createElement('script');
imported2.src = 'http://haghish.com/statax/sh_main.js';
document.head.appendChild(imported2);


//********************************************************
//* LOAD THE Statax.css
//********************************************************
var cssId = 'myCss';  // you could encode the css path itself to generate id..
if (!document.getElementById(cssId))
{
    var head  = document.getElementsByTagName('head')[0];
    var link  = document.createElement('link');
    link.id   = cssId;
    link.rel  = 'stylesheet';
    link.type = 'text/css';
    link.href = 'http://haghish.com/statax/Statax.css';
    link.media = 'all';
    head.appendChild(link);


//********************************************************
//* AUTOMATICALLY RUN SCRIPT
//********************************************************
window.onload = function() 
    { 
        sh_highlightDocument();
    }; 



}
