/*

			Statx Package : JavaScript Syntax Highlighter for Stata
					   
					   Developed by E. F. Haghish (2014)
			  Center for Medical Biometry and Medical Informatics
						University of Freiburg, Germany
						
						  haghish@imbi.uni-freiburg.de

		
                   The Statax Package comes with no warranty    	
				  
				  
	SHJS - Syntax Highlighting in JavaScript
	Copyright (C) 2007, 2008 gnombat@users.sourceforge.net
	License: http://shjs.sourceforge.net/doc/gplv3.html
	
	
	Statax Versions
	==============================
	
	Statax 1.0  September, 2015
*/

		
program define stataxmain
    version 11
	
	tempname canvas 
	capture file open `canvas' using "$statax" , write text append
			
	********************************************************************
	* This is the main engine
	********************************************************************
				
	file write `canvas' _n(2) `"<script type="text/javascript">"' _n(2) ///
				"if (! this.sh_languages) {" _n ///
				  _skip(2)"this.sh_languages = {};" _n ///
				"}" _n ///
				"var sh_requests = {};" _n(2) ///
				"function sh_isEmailAddress(url) {" _n ///
				  _skip(2)"if (/^mailto:/.test(url)) {" _n ///
					_skip(4)"return false;" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"return url.indexOf('@') !== -1;" _n ///
				"}" _n(2) ///
				"function sh_setHref(tags, numTags, inputString) {" _n ///
				  _skip(2)"var url = inputString.substring(tags[numTags - 2].pos, tags[numTags - 1].pos);" _n ///
				  _skip(2)"if (url.length >= 2 && url.charAt(0) === '<' && url.charAt(url.length - 1) === '>') {" _n ///
					_skip(4)"url = url.substr(1, url.length - 2);" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"if (sh_isEmailAddress(url)) {" _n ///
					_skip(4)"url = 'mailto:' + url;" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"tags[numTags - 2].node.href = url;" _n ///
				"}" _n(2)  ///
				/*
				Konqueror has a bug where the regular expression /$/g will not match at the end
				of a line more than once:

				  var regex = /$/g;
				  var match;

				  var line = '1234567890';
				  regex.lastIndex = 10;
				  match = regex.exec(line);

				  var line2 = 'abcde';
				  regex.lastIndex = 5;
				  match = regex.exec(line2);  // fails
				*/ ///
				"function sh_konquerorExec(s) {" _n ///
				  _skip(2)"var result = [''];" _n ///
				  _skip(2)"result.index = s.length;" _n ///
				  _skip(2)"result.input = s;" _n ///
				  _skip(2)"return result;" _n ///
				"}" _n(2) ///
				/*
				Highlights all elements containing source code in a text string.  The return
				value is an array of objects, each representing an HTML start or end tag.  Each
				object has a property named pos, which is an integer representing the text
				offset of the tag. Every start tag also has a property named node, which is the
				DOM element started by the tag. End tags do not have this property.
				@param  inputString  a text string
				@param  language  a language definition object
				@return  an array of tag objects
				*/ ///
				"function sh_highlightString(inputString, language) {" _n ///
				  _skip(2)"if (/Konqueror/.test(navigator.userAgent)) {" _n ///
					_skip(4)"if (! language.konquered) {" _n ///
					  _skip(6)"for (var s = 0; s < language.length; s++) {" _n ///
						_skip(8)"for (var p = 0; p < language[s].length; p++) {" _n ///
						  _skip(10)"var r = language[s][p][0];" _n ///
						  _skip(10)"if (r.source === '$') {" _n ///
							_skip(12)"r.exec = sh_konquerorExec;" _n ///
						  _skip(10)"}" _n ///
						_skip(8)"}" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"language.konquered = true;" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"var a = document.createElement('a');" _n ///
				  _skip(2)"var span = document.createElement('span');" _n(2) ///
				  /// the result
				  _skip(2)"var tags = [];" _n ///
				  _skip(2)"var numTags = 0;" _n(2) ///
				  /// each element is a pattern object from language
				  _skip(2)"var patternStack = [];" _n(2) ///
				  /// the current position within inputString
				  _skip(2)"var pos = 0;" _n(2) ///
				  /// the name of the current style, or null if there is no current style
				  _skip(2)"var currentStyle = null;" _n(2) ///
				  _skip(2)"var output = function(s, style) {" _n ///
					_skip(4)"var length = s.length;" _n ///
					/// this is more than just an optimization - we don't want to output empty <span></span> elements
					_skip(4)"if (length === 0) {" _n ///
					  _skip(6)"return;" _n ///
					_skip(4)"}" _n ///
					_skip(4)"if (! style) {" _n ///
					  _skip(6)"var stackLength = patternStack.length;" _n ///
					  _skip(6)"if (stackLength !== 0) {" _n ///
						_skip(8)"var pattern = patternStack[stackLength - 1];" _n ///
						/// check whether this is a state or an environment
						_skip(8)"if (! pattern[3]) {" _n ///
						  /// it's not a state - it's an environment; use the style for this environment
						  _skip(10)"style = pattern[1];" _n ///
						_skip(8)"}" _n ///
					  _skip(6)"}" _n ///
					_skip(4)"}" _n ///
					_skip(4)"if (currentStyle !== style) {" _n ///
					  _skip(6)"if (currentStyle) {" _n ///
						_skip(8)"tags[numTags++] = {pos: pos};" _n ///
						_skip(8)"if (currentStyle === 'sh_url') {" _n ///
						  _skip(10)"sh_setHref(tags, numTags, inputString);" _n ///
						_skip(8)"}" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"if (style) {" _n ///
						_skip(8)"var clone;" _n ///
						_skip(8)"if (style === 'sh_url') {" _n ///
						  _skip(10)"clone = a.cloneNode(false);" _n ///
						_skip(8)"}" _n ///
						_skip(8)"else {" _n ///
						  _skip(10)"clone = span.cloneNode(false);" _n ///
						_skip(8)"}" _n ///
						_skip(8)"clone.className = style;" _n ///
						_skip(8)"tags[numTags++] = {node: clone, pos: pos};" _n ///
					  _skip(6)"}" _n ///
					_skip(4)"}" _n ///
					_skip(4)"pos += length;" _n ///
					_skip(4)"currentStyle = style;" _n ///
				  _skip(2)"};" _n(2) ///
				  _skip(2)"var endOfLinePattern = /\r\n|\r|\n/g;" _n ///
				  _skip(2)"endOfLinePattern.lastIndex = 0;" _n ///
				  _skip(2)"var inputStringLength = inputString.length;" _n ///
				  _skip(2)"while (pos < inputStringLength) {" _n ///
					_skip(4)"var start = pos;" _n ///
					_skip(4)"var end;" _n ///
					_skip(4)"var startOfNextLine;" _n ///
					_skip(4)"var endOfLineMatch = endOfLinePattern.exec(inputString);" _n ///
					_skip(4)"if (endOfLineMatch === null) {" _n ///
					  _skip(6)"end = inputStringLength;" _n ///
					  _skip(6)"startOfNextLine = inputStringLength;" _n ///
					_skip(4)"}" _n ///
					_skip(4)"else {" _n ///
					  _skip(6)"end = endOfLineMatch.index;" _n ///
					  _skip(6)"startOfNextLine = endOfLinePattern.lastIndex;" _n ///
					_skip(4)"}" _n(2) ///
					_skip(4)"var line = inputString.substring(start, end);" _n(2) ///
					_skip(4)"var matchCache = [];" _n ///
					_skip(4)"for (;;) {" _n ///
					  _skip(6)"var posWithinLine = pos - start;" _n(2) ///
					  _skip(6)"var stateIndex;" _n ///
					  _skip(6)"var stackLength = patternStack.length;" _n ///
					  _skip(6)"if (stackLength === 0) {" _n ///
						_skip(8)"stateIndex = 0;" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"else {" _n ///
						/// get the next state
						_skip(8)"stateIndex = patternStack[stackLength - 1][2];" _n ///
					  _skip(6)"}" _n(2) ///
					  _skip(6)"var state = language[stateIndex];" _n ///
					  _skip(6)"var numPatterns = state.length;" _n ///
					  _skip(6)"var mc = matchCache[stateIndex];" _n ///
					  _skip(6)"if (! mc) {" _n ///
						_skip(8)"mc = matchCache[stateIndex] = [];" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"var bestMatch = null;" _n ///
					  _skip(6)"var bestPatternIndex = -1;" _n ///
					  _skip(6)"for (var i = 0; i < numPatterns; i++) {" _n ///
						_skip(8)"var match;" _n ///
						_skip(8)"if (i < mc.length && (mc[i] === null || posWithinLine <= mc[i].index)) {" _n ///
						  _skip(10)"match = mc[i];" _n ///
						_skip(8)"}" _n ///
						_skip(8)"else {" _n ///
						  _skip(10)"var regex = state[i][0];" _n ///
						  _skip(10)"regex.lastIndex = posWithinLine;" _n ///
						  _skip(10)"match = regex.exec(line);" _n ///
						  _skip(10)"mc[i] = match;" _n ///
						_skip(8)"}" _n ///
						_skip(8)"if (match !== null && (bestMatch === null || match.index < bestMatch.index)) {" _n ///
						  _skip(10)"bestMatch = match;" _n ///
						  _skip(10)"bestPatternIndex = i;" _n ///
						  _skip(10)"if (match.index === posWithinLine) {" _n ///
							_skip(12)"break;" _n ///
						  _skip(10)"}" _n ///
						_skip(8)"}" _n ///
					  _skip(6)"}" _n(2) ///
					  _skip(6)"if (bestMatch === null) {" _n ///
						_skip(8)"output(line.substring(posWithinLine), null);" _n ///
						_skip(8)"break;" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"else {" _n ///
						/// got a match
						_skip(8)"if (bestMatch.index > posWithinLine) {" _n ///
						  _skip(10)"output(line.substring(posWithinLine, bestMatch.index), null);" _n ///
						_skip(8)"}" _n(2) ///
						_skip(8)"var pattern = state[bestPatternIndex];" _n ///
						_skip(8)"var newStyle = pattern[1];" _n ///
						_skip(8)"var matchedString;" _n ///
						_skip(8)"if (newStyle instanceof Array) {" _n ///
						  _skip(10)"for (var subexpression = 0; subexpression < newStyle.length; subexpression++) {" _n ///
							_skip(12)"matchedString = bestMatch[subexpression + 1];" _n ///
							_skip(12)"output(matchedString, newStyle[subexpression]);" _n ///
						  _skip(10)"}" _n ///
						_skip(8)"}" _n ///
						_skip(8)"else {" _n ///
						  _skip(10)"matchedString = bestMatch[0];" _n ///
						  _skip(10)"output(matchedString, newStyle);" _n ///
						_skip(8)"}" _n(2) ///
						_skip(8)"switch (pattern[2]) {" _n ///
						_skip(8)"case -1:" _n(2) ///
						  /// do nothing
						  _skip(10)"break;" _n ///
						_skip(8)"case -2:" _n ///
						  /// exit
						  _skip(10)"patternStack.pop();" _n ///
						  _skip(10)"break;" _n ///
						_skip(8)"case -3:" _n ///
						  /// exitall
						  _skip(10)"patternStack.length = 0;" _n ///
						  _skip(10)"break;" _n ///
						_skip(8)"default:" _n ///
						  /// this was the start of a delimited pattern or a state/environment
						  _skip(10)"patternStack.push(pattern);" _n ///
						  _skip(10)"break;" _n ///
						_skip(8)"}" _n ///
					  _skip(6)"}" _n ///
					_skip(4)"}" _n(2) ///
					/// end of the line
					_skip(4)"if (currentStyle) {" _n ///
					  _skip(6)"tags[numTags++] = {pos: pos};" _n ///
					  _skip(6)"if (currentStyle === 'sh_url') {" _n ///
						_skip(8)"sh_setHref(tags, numTags, inputString);" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"currentStyle = null;" _n ///
					_skip(4)"}" _n ///
					_skip(4)"pos = startOfNextLine;" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"return tags;" _n ///
				"}" _n(4) ///
				/// /////////////////////////////////////////////////////////////////////////////
				/// DOM-dependent functions
				"function sh_getClasses(element) {" _n ///
				  _skip(2)"var result = [];" _n ///
				  _skip(2)"var htmlClass = element.className;" _n ///
				  _skip(2)"if (htmlClass && htmlClass.length > 0) {" _n ///
					_skip(4)"var htmlClasses = htmlClass.split(' ');" _n ///
					_skip(4)"for (var i = 0; i < htmlClasses.length; i++) {" _n ///
					  _skip(6)"if (htmlClasses[i].length > 0) {" _n ///
						_skip(8)"result.push(htmlClasses[i]);" _n ///
					  _skip(6)"}" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"return result;" _n ///
				"}" _n(2) ///
				"function sh_addClass(element, name) {" _n ///
				  _skip(2)"var htmlClasses = sh_getClasses(element);" _n ///
				  _skip(2)"for (var i = 0; i < htmlClasses.length; i++) {" _n ///
					_skip(4)"if (name.toLowerCase() === htmlClasses[i].toLowerCase()) {" _n ///
					  _skip(6)"return;" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"htmlClasses.push(name);" _n ///
				  _skip(2)"element.className = htmlClasses.join(' ');" _n ///
				"}" _n(2) ///
				/**
				Extracts the tags from an HTML DOM NodeList.
				@param  nodeList  a DOM NodeList
				@param  result  an object with text, tags and pos properties
				*/ ///
				"function sh_extractTagsFromNodeList(nodeList, result) {" _n ///
				  _skip(2)"var length = nodeList.length;" _n ///
				  _skip(2)"for (var i = 0; i < length; i++) {" _n ///
					_skip(4)"var node = nodeList.item(i);" _n ///
					_skip(4)"switch (node.nodeType) {" _n ///
					_skip(4)"case 1:" _n ///
					  _skip(6)"if (node.nodeName.toLowerCase() === 'br') {" _n ///
						_skip(8)"var terminator;" _n ///
						_skip(8)"if (/MSIE/.test(navigator.userAgent)) {" _n ///
						  _skip(12)"terminator = '\r';" _n ///
						_skip(8)"}" _n ///
						_skip(8)"else {" _n ///
						  _skip(12)"terminator = '\n';" _n ///
						_skip(8)"}" _n ///
						_skip(8)"result.text.push(terminator);" _n ///
						_skip(8)"result.pos++;" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"else {" _n ///
						_skip(8)"result.tags.push({node: node.cloneNode(false), pos: result.pos});" _n ///
						_skip(8)"sh_extractTagsFromNodeList(node.childNodes, result);" _n ///
						_skip(8)"result.tags.push({pos: result.pos});" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"break;" _n ///
					_skip(4)"case 3:" _n ///
					_skip(4)"case 4:" _n ///
					  _skip(6)"result.text.push(node.data);" _n ///
					  _skip(6)"result.pos += node.length;" _n ///
					  _skip(6)"break;" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"}" _n ///
				"}" _n(2) ///
				/**
				Extracts the tags from the text of an HTML element. The extracted tags will be
				returned as an array of tag objects. See sh_highlightString for the format of
				the tag objects.
				@param  element  a DOM element
				@param  tags  an empty array; the extracted tag objects will be returned in it
				@return  the text of the element
				@see  sh_highlightString
				*/ ///
				"function sh_extractTags(element, tags) {" _n ///
				  _skip(2)"var result = {};" _n ///
				  _skip(2)"result.text = [];" _n ///
				  _skip(2)"result.tags = tags;" _n ///
				  _skip(2)"result.pos = 0;" _n ///
				  _skip(2)"sh_extractTagsFromNodeList(element.childNodes, result);" _n ///
				  _skip(2)"return result.text.join('');" _n ///
				"}" _n(2) ///
				/**
				Merges the original tags from an element with the tags produced by highlighting.
				@param  originalTags  an array containing the original tags
				@param  highlightTags  an array containing the highlighting tags - these must not overlap
				@result  an array containing the merged tags
				*/ ///
				"function sh_mergeTags(originalTags, highlightTags) {" _n ///
				  _skip(2)"var numOriginalTags = originalTags.length;" _n ///
				  _skip(2)"if (numOriginalTags === 0) {" _n ///
					_skip(4)"return highlightTags;" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"var numHighlightTags = highlightTags.length;" _n ///
				  _skip(2)"if (numHighlightTags === 0) {" _n ///
					_skip(4)"return originalTags;" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"var result = [];" _n ///
				  _skip(2)"var originalIndex = 0;" _n ///
				  _skip(2)"var highlightIndex = 0;" _n(2) ///
				  _skip(2)"while (originalIndex < numOriginalTags && highlightIndex < numHighlightTags) {" _n ///
					_skip(4)"var originalTag = originalTags[originalIndex];" _n ///
					_skip(4)"var highlightTag = highlightTags[highlightIndex];" _n(2) ///
					_skip(4)"if (originalTag.pos <= highlightTag.pos) {" _n ///
					  _skip(6)"result.push(originalTag);" _n ///
					  _skip(6)"originalIndex++;" _n ///
					_skip(4)"}" _n ///
					_skip(4)"else {" _n ///
					  _skip(6)"result.push(highlightTag);" _n ///
					  _skip(6)"if (highlightTags[highlightIndex + 1].pos <= originalTag.pos) {" _n ///
						_skip(8)"highlightIndex++;" _n ///
						_skip(8)"result.push(highlightTags[highlightIndex]);" _n ///
						_skip(8)"highlightIndex++;" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"else {" _n ///
						/// new end tag
						_skip(8)"result.push({pos: originalTag.pos});" _n(2) ///
						/// new start tag
						_skip(8)"highlightTags[highlightIndex] = {node: highlightTag.node.cloneNode(false), pos: originalTag.pos};" _n ///
					  _skip(6)"}" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"while (originalIndex < numOriginalTags) {" _n ///
					_skip(4)"result.push(originalTags[originalIndex]);" _n ///
					_skip(4)"originalIndex++;" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"while (highlightIndex < numHighlightTags) {" _n ///
					_skip(4)"result.push(highlightTags[highlightIndex]);" _n ///
					_skip(4)"highlightIndex++;" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"return result;" _n ///
				"}" _n(2) ///
				/**
				Inserts tags into text.
				@param  tags  an array of tag objects
				@param  text  a string representing the text
				@return  a DOM DocumentFragment representing the resulting HTML
				*/ ///
				"function sh_insertTags(tags, text) {" _n ///
				  _skip(2)"var doc = document;" _n(2) ///
				  _skip(2)"var result = document.createDocumentFragment();" _n ///
				  _skip(2)"var tagIndex = 0;" _n ///
				  _skip(2)"var numTags = tags.length;" _n ///
				  _skip(2)"var textPos = 0;" _n ///
				  _skip(2)"var textLength = text.length;" _n ///
				  _skip(2)"var currentNode = result;" _n ///
				  /// output one tag or text node every iteration
				  _skip(2)"while (textPos < textLength || tagIndex < numTags) {" _n ///
					_skip(4)"var tag;" _n ///
					_skip(4)"var tagPos;" _n ///
					_skip(4)"if (tagIndex < numTags) {" _n ///
					  _skip(6)"tag = tags[tagIndex];" _n ///
					  _skip(6)"tagPos = tag.pos;" _n ///
					_skip(4)"}" _n ///
					_skip(4)"else {" _n ///
					  _skip(6)"tagPos = textLength;" _n ///
					_skip(4)"}" _n(2) ///
					_skip(4)"if (tagPos <= textPos) {" _n ///
					  /// output the tag
					  _skip(6)"if (tag.node) {" _n ///
						/// start tag
						_skip(8)"var newNode = tag.node;" _n ///
						_skip(8)"currentNode.appendChild(newNode);" _n ///
						_skip(8)"currentNode = newNode;" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"else {" _n ///
						/// end tag
						_skip(8)"currentNode = currentNode.parentNode;" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"tagIndex++;" _n ///
					_skip(4)"}" _n ///
					_skip(4)"else {" _n ///
					  /// output text
					  _skip(6)"currentNode.appendChild(doc.createTextNode(text.substring(textPos, tagPos)));" _n ///
					  _skip(6)"textPos = tagPos;" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"return result;" _n ///
				"}" _n(2) ///
				/**
				Highlights an element containing source code.  Upon completion of this function,
				the element will have been placed in the "sh_sourceCode" class.
				@param  element  a DOM <pre> element containing the source code to be highlighted
				@param  language  a language definition object
				*/ ///
				"function sh_highlightElement(element, language) {" _n ///
				  _skip(2)"sh_addClass(element, 'sh_sourceCode');" _n ///
				  _skip(2)"var originalTags = [];" _n ///
				  _skip(2)"var inputString = sh_extractTags(element, originalTags);" _n ///
				  _skip(2)"var highlightTags = sh_highlightString(inputString, language);" _n ///
				  _skip(2)"var tags = sh_mergeTags(originalTags, highlightTags);" _n ///
				  _skip(2)"var documentFragment = sh_insertTags(tags, inputString);" _n ///
				  _skip(2)"while (element.hasChildNodes()) {" _n ///
					_skip(4)"element.removeChild(element.firstChild);" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"element.appendChild(documentFragment);" _n ///
				"}" _n(2) ///
				"function sh_getXMLHttpRequest() {" _n ///
				  _skip(2)"if (window.ActiveXObject) {" _n ///
					_skip(4)"return new ActiveXObject('Msxml2.XMLHTTP');" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"else if (window.XMLHttpRequest) {" _n ///
					_skip(4)"return new XMLHttpRequest();" _n ///
				  _skip(2)"}" _n ///
				  _skip(2)"throw 'No XMLHttpRequest implementation available';" _n ///
				"}" _n ///
				"function sh_load(language, element, prefix, suffix) {" _n ///
				  _skip(2)"if (language in sh_requests) {" _n ///
					_skip(4)"sh_requests[language].push(element);" _n ///
					_skip(4)"return;" _n ///
				  _skip(2)"}" _n(2) ///
				  _skip(2)"sh_requests[language] = [element];" _n ///
				  _skip(2)"var request = sh_getXMLHttpRequest();" _n ///
				  _skip(2)"var url = prefix + 'sh_' + language + suffix;" _n ///
				  _skip(2)"request.open('GET', url, true);" _n ///
				  _skip(2)"request.onreadystatechange = function () {" _n ///
					_skip(4)"if (request.readyState === 4) {" _n ///
					  _skip(6)"try {" _n ///
						_skip(8)"if (! request.status || request.status === 200) {" _n ///
						  _skip(10)"eval(request.responseText);" _n ///
						  _skip(10)"var elements = sh_requests[language];" _n ///
						  _skip(10)"for (var i = 0; i < elements.length; i++) {" _n ///
							_skip(12)"sh_highlightElement(elements[i], sh_languages[language]);" _n ///
						  _skip(10)"}" _n ///
						_skip(8)"}" _n ///
						_skip(8)"else {" _n ///
						  _skip(10)"throw 'HTTP error: status ' + request.status;" _n ///
						_skip(8)"}" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"finally {" _n ///
						_skip(8)"request = null;" _n ///
					  _skip(6)"}" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"};" _n ///
				  _skip(2)"request.send(null);" _n ///
				"}" _n(2) ///
				/**
				Highlights all elements containing source code on the current page. Elements
				containing source code must be "pre" elements with a "class" attribute of
				"sh_LANGUAGE", where LANGUAGE is a valid language identifier; e.g., "sh_java"
				identifies the element as containing "java" language source code.
				*/ ///
				"function sh_highlightDocument(prefix, suffix) {" _n ///
				  _skip(2)"var nodeList = document.getElementsByTagName('pre');" _n ///
				  _skip(2)"for (var i = 0; i < nodeList.length; i++) {" _n ///
					_skip(4)"var element = nodeList.item(i);" _n ///
					_skip(4)"var htmlClasses = sh_getClasses(element);" _n ///
					_skip(4)"for (var j = 0; j < htmlClasses.length; j++) {" _n ///
					  _skip(6)"var htmlClass = htmlClasses[j].toLowerCase();" _n ///
					  _skip(6)"if (htmlClass === 'sh_sourcecode') {" _n ///
						_skip(8)"continue;" _n ///
					  _skip(6)"}" _n ///
					  _skip(6)"if (htmlClass.substr(0, 3) === 'sh_') {" _n ///
						_skip(8)"var language = htmlClass.substring(3);" _n ///
						_skip(8)"if (language in sh_languages) {" _n ///
						  _skip(10)"sh_highlightElement(element, sh_languages[language]);" _n ///
						_skip(8)"}" _n ///
						_skip(8)"else if (typeof(prefix) === 'string' && typeof(suffix) === 'string') {" _n ///
						  _skip(10)"sh_load(language, element, prefix, suffix);" _n ///
						_skip(8)"}" _n ///
						_skip(8)"else {" _n ///
						  ///_skip(10)"throw 'Found <pre> element with class="' + htmlClass + '", but no such language exists';" _n ///
						  _skip(10)"throw 'Found <pre> element with class="`"""' "' + htmlClass + '" `"""'", but no such language exists';" _n ///
						_skip(8)"}" _n ///
						_skip(8)"break;" _n ///
					  _skip(6)"}" _n ///
					_skip(4)"}" _n ///
				  _skip(2)"}" _n(2) ///
				"}" _n ///
				"</script>" _n(4)	
	
	
	file close `canvas'
end
