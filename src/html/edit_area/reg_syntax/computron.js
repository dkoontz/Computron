editAreaLoader.load_syntax["computron"] = {
	'COMMENT_SINGLE' : {1 : '#'},
	'COMMENT_MULTI' : {},
	'QUOTEMARKS' : {},
	'KEYWORD_CASE_SENSITIVE' : true,
	'KEYWORDS' : {
		'reserved' : [
			'copy', 'alias', 'show', 'info',
			'add', 'subtract', 'multiply', 'divide', 'divide_full', 
			'compare', 'jump', 'jump_if_less', 'jump_if_greater', 'jump_if_equal',
		]
	},
	'OPERATORS' :[],
	'DELIMITERS' :[
		'[', ']'
	],
	'REGEXPS' : {
		'numbers' : {
			'search' : '()(-?[0-9]+)()',
			'class' : 'numbers',
			'modifiers' : 'g',
			'execute' : 'before' 
		},
		'symbols' : {
			'search' : '()(:\\w+)()',
			'class' : 'symbols',
			'modifiers' : 'g',
			'execute' : 'before'
		}
	},
	'STYLES' : {
		'COMMENTS': 'color: #AAAAAA;',
		'QUOTESMARKS': 'color: #660066;',
		'KEYWORDS' : {
			'reserved' : 'font-weight: bold; color: #0000FF;'
		},
		'OPERATORS' : 'color: #993300;',
		'DELIMITERS' : 'color: #993300;',
		'REGEXPS' : {
			'variables' : 'color: #E0BD54;',
			'numbers' : 'color: green;',
			'constants' : 'color: #00AA00;',
			'symbols' : 'color: #879EFA;'
		}	
	}
};
