function withOpacity(variableName) {
  // const hsler = /hsl\((.+)\)/i

  return ({ opacityValue }) => {
    if (opacityValue !== undefined) {
      return `hsla(var(${variableName}), ${opacityValue})`
    }

    return `hsl(var(${variableName}))`
  }
}

module.exports = {
  purge: {
    content: [
	  "./layouts/**/*.html",
	  "./content/**/*.md",
      "./content/**/*.html"
    ],
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
	 colors: {
        'th-primary': withOpacity("--primary"),
        'th-secondary': withOpacity("--secondary"),
        'th-muted': withOpacity("--muted"),
		'th-highlight': withOpacity("--highlight")
      },
	},
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
