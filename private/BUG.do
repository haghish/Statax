qui log using 0, replace

sysuse auto, clear
replace rep78 = rep78/2

qui log c

markdoc 0, exp(html) replace statax
