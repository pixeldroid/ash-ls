LIB_NAME = 'Ash'
LIB_VERSION_FILE = File.join('lib', 'src', 'ash', 'Ash.ls')

begin
  load(File.join(ENV['HOME'], '.loom', 'tasks', 'loomlib.rake'))
rescue LoadError
  abort([
    'error: missing loomlib.rake',
    '  please install loomtasks before running this Rakefile:',
    '  https://github.com/pixeldroid/loomtasks/',
  ].join("\n"))
end

# Note: Due to a peculiarity of the core Loomlibs,
#       a command line app will crash if it links in display list classes
#       see https://loomsdk.com/forums/feedback/topics/unittest-framework-for-loomscript/posts/5210
#
#       So, for now we are using the gui app as test harness
desc [
  "runs the spec tests (shorthand for rake gui:run)",
].join("\n")
task :test => 'gui:run'
