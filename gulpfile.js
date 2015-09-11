var gulp = require('gulp');
var sass = require('gulp-sass');
var watch = require('gulp-watch');
var cssmin = require('gulp-minify-css');
var concat = require('gulp-concat');

var paths = {
        styles: {
                sass: {
                        src: 'stylesheets/sass/**/*.scss',
                        dest: 'stylesheets/css'
                },
                css: {
                        src: ['stylesheets/css/*.css', 'node_modules/normalize-css/normalize.css'],
                        dest: 'stylesheets/min/'
                }
        }
};

gulp.task('sass', function() {
        gulp.src(paths.styles.sass.src)
          .pipe(sass())
          .pipe(gulp.dest(paths.styles.sass.dest));
});

gulp.task('cssmin', function() {
        gulp.src(paths.styles.css.src)
          .pipe(cssmin())
          .pipe(concat('main.min.css'))
          .pipe(gulp.dest(paths.styles.css.dest));
});

gulp.task('watch', function() {
        gulp.watch(paths.styles.sass.src, function(event) {
                gulp.start('sass');
        });

        gulp.watch(paths.styles.css.src, function(event) {
                gulp.start('cssmin');
        });
});

gulp.task('default', ['sass', 'cssmin', 'watch']);
