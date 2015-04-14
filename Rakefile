# encoding: utf-8

require 'etc'
require 'fileutils'
require 'json'
require 'rake/clean'

@lib_loom_config = nil
@test_loom_config = nil

CLEAN.include ["lib/build/**", "test/bin/**", "test/build/**"]
CLOBBER.include ["lib/build", "test/bin", "test/build", "releases"]
Rake::Task[:clobber].enhance ["lib:uninstall"]


task :default => :list_targets

task :list_targets do |t, args|
	puts "Ash Rakefile running on Ruby #{RUBY_VERSION}"
	system("rake -T")
	puts ''
end


LIBRARY = "lib/build/Ash.loomlib"

FileList['lib/src/**/*.ls'].each do |src|
	file LIBRARY => src
end

file LIBRARY do |t, args|
	puts "[file] creating #{t.name}..."

	sdk_version = lib_config['sdk_version']

	Dir.chdir("lib") do
		Dir.mkdir('build') unless Dir.exists?('build')
		cmd = %Q[#{sdk_root}/#{sdk_version}/tools/lsc Ash.build]
		try(cmd, "failed to compile .loomlib")
	end
end


APP = "test/bin/Main.loom"

FileList['test/src/**/*.ls'].each do |src|
	file APP => src
end

file APP => LIBRARY do |t, args|
	puts "[file] creating #{t.name}..."

	sdk_version = test_config['sdk_version']
	file_installed = "#{sdk_root}/#{sdk_version}/libs/Ash.loomlib"

	Rake::Task["lib:install"].invoke unless FileUtils.uptodate?(file_installed, [LIBRARY])

	Dir.chdir("test") do
		Dir.mkdir('bin') unless Dir.exists?('bin')
		cmd = %Q[#{sdk_root}/#{sdk_version}/tools/lsc]
		try(cmd, "failed to compile .loom")
	end

	puts ''
end


namespace :lib do

	desc "builds Ash.loomlib for the SDK specified in lib/loom.config"
	task :build => LIBRARY do |t, args|
		puts "[#{t.name}] task completed, find .loomlib in lib/build/"
		puts ''
	end

	desc "prepares sdk-specific Ash.loomlib for release"
	task :release => LIBRARY do |t, args|
		lib = 'lib/build/Ash.loomlib'
		sdk = lib_config['sdk_version']
		ext = '.loomlib'
		release_dir = 'releases'

		Dir.mkdir(release_dir) unless Dir.exists?(release_dir)

		lib_release = %Q[#{File.basename(lib, ext)}-#{sdk}#{ext}]
		FileUtils.copy(lib, "#{release_dir}/#{lib_release}")

		puts "[#{t.name}] task completed, find #{lib_release} in #{release_dir}/"
		puts ''
	end

	desc "installs Ash.loomlib into the SDK specified in lib/loom.config"
	task :install => LIBRARY do |t, args|
		lib = 'lib/build/Ash.loomlib'
		sdk_version = lib_config['sdk_version']
		libs_path = "#{sdk_root}/#{sdk_version}/libs"

		cmd = %Q[cp #{lib} #{libs_path}]
		try(cmd, "failed to install lib")

		puts "[#{t.name}] task completed, Ash.loomlib installed for #{sdk_version}"
		puts ''
	end

	desc "removes Ash.loomlib from the SDK specified in lib/loom.config"
	task :uninstall do |t, args|
		sdk_version = lib_config['sdk_version']
		lib = "#{sdk_root}/#{sdk_version}/libs/Ash.loomlib"

		if (File.exists?(lib))
			cmd = %Q[rm -f #{lib}]
			try(cmd, "failed to remove lib")
			puts "[#{t.name}] task completed, Ash.loomlib removed from #{sdk_version}"
		else
			puts "[#{t.name}] nothing to do;  no Ash.loomlib found in #{sdk_version} sdk"
		end
		puts ''
	end

	desc "lists libs installed for the SDK specified in lib/loom.config"
	task :show do |t, args|
		sdk_version = lib_config['sdk_version']

		cmd = %Q[ls -l #{sdk_root}/#{sdk_version}/libs]
		try(cmd, "failed to list contents of #{sdk_version} libs directory")

		puts ''
	end

end

namespace :test do

	desc "builds AshTest as Main.loom with the SDK specified in test/loom.config"
	task :build => APP do |t, args|
		puts "[#{t.name}] task completed, find .loom in test/bin/"
		puts ''
	end

	desc "runs AshTest (Main.loom)"
	task :run => APP do |t, args|
		puts "[#{t.name}] running #{t.prerequisites[0]}..."

		sdk_version = test_config['sdk_version']

		Dir.chdir("test") do
			begin
				# magically, this binary loads bin/Main.loom from the current directory
				cmd = %Q[#{sdk_root}/#{sdk_version}/bin/LoomDemo.app/Contents/MacOS/LoomDemo\n]
				try(cmd, "failed to launch #{t.prerequisites[0]}")
			rescue Exception => e
				puts ''
			end
		end

		puts ''
	end

end


def lib_config
	@lib_loom_config || (@lib_loom_config = JSON.parse(File.read(File.join('lib', 'loom.config'))))
end

def test_config
	@test_loom_config || (@test_loom_config = JSON.parse(File.read(File.join('test', 'loom.config'))))
end

def sdk_root
	File.join(Dir.home, '.loom', 'sdks')
end

def try(cmd, failure_message)
	abort("◈ #{failure_message}") if (exec_with_echo(cmd) != 0)
end

def exec_with_echo(cmd)
	puts(cmd)
	stdout = %x[#{cmd}]
	puts(stdout) unless stdout.empty?
	$?.exitstatus
end
