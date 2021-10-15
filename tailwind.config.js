module.exports = {
	content: [
		"./layouts/**/*.html",
		"./content/**/*.md",
		"./content/**/*.html"
	],
	darkMode: 'media', // or 'media' or 'class'
	theme: {
		extend: {
			fontFamily: {
				'display': ['GT Sectra'],
				'mono': ['akkurat-mono']
			}
		},
	},
	variants: {
		extend: {
			borderWidth: ['hover'],
		},
	},
	plugins: [require("tailwindcss-padding-safe")()]
};
