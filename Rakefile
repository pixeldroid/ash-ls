
LIB_NAME = 'Ash'
LIB_VERSION_FILE = File.join('lib', 'src', 'ash', 'core', 'Engine.ls')

begin
  load(File.join(ENV['HOME'], '.loom', 'tasks', 'loomlib.rake'))
  load(File.join(ENV['HOME'], '.loom', 'tasks', 'loomlib_demo.rake'))
rescue LoadError
  abort([
    'error: missing loomtasks',
    '  please install loomtasks v1.1.0 or later before running this Rakefile:',
    '  https://github.com/pixeldroid/loomtasks/',
  ].join("\n"))
end

# Note: Due to a peculiarity of the core Loomlibs,
#       a command line app will crash if it links in display list classes
#       see https://loomsdk.com/forums/feedback/topics/unittest-framework-for-loomscript/posts/5210
#
#       So, for now we are using the demo gui app as test harness, and disabling the normal test tasks
Rake::Task['test'].clear # no gui demo for this project
Rake::Task['test:build'].clear # no gui demo for this project
Rake::Task['test:ci'].clear # no gui demo for this project
Rake::Task['test:run'].clear # no gui demo for this project
Rake::Task['demo:cli'].clear # no gui demo for this project
