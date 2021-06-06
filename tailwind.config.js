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
  darkMode: 'media', // or 'media' or 'class'
  theme: {
    extend: {
	  fontFamily: {
        'display': ['GT Sectra'],
		'mono': ['akkurat-mono']
      },
      colors: {
        'th-primary': withOpacity("--primary"),
        'th-secondary': withOpacity("--secondary"),
        'th-input': withOpacity("--input"),
        'th-muted': withOpacity("--muted"),
        'th-highlight': withOpacity("--highlight"),
        'th-background': withOpacity("--background")
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
