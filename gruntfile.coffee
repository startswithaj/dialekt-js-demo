module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    app: 'app'
    dist: 'dist'
    nonull: true

    connect:
      server:
        options:
          port: 8080
          base: 'www/'
          livereload: true

    copy:
      build:
        cwd: 'src/'
        src: [ 'index.html', 'css/*.css' ]
        dest: 'www/'
        expand: true

    browserify:
      dist:
        files:
          'www/js/app.js': ['src/coffee/*.coffee']
        options:
          transform: ['coffeeify']
          browserifyOptions:
            extensions: ['.coffee']
          bundleOptions:
            debug: true

    watch:
      options:
        livereload: true
      browserify:
        files: ['src/coffee/**']
        tasks: ['browserify']
      css:
        files: 'src/css/**'
        tasks: ['copy']
      # autoprefixer does it in place so must be after cssmin
      html:
        files: ['src/index.html']
        tasks: ['copy']

    'gh-pages': 
      options: {
        base: 'www'
        message: 'Auto-generated commit: Updating gh-pages'
      }
      src: ['**/*']

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-gh-pages'

  grunt.registerTask 'default', ['browserify', 'copy', 'connect', 'watch']
  grunt.registerTask 'prod',  ['browserify', 'copy', 'gh-pages']
