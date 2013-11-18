module.exports = function(grunt) {

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		cssmin: {
			combine: {
				files: {
					'min/min.css': ['css/index.css', 'css/common.css', 'css/reset.css']
				}
			}
		},
		watch: {
			files: ['css/index.css', 'css/common.css', 'css/reset.css'],
			tasks: ['cssmin']
		}
	});

	grunt.loadNpmTasks('grunt-contrib-cssmin');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.registerTask('default', ['cssmin', 'watch']);

};
