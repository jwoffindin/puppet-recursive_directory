require 'puppet'
require 'find'

File.expand_path('../../../..', __FILE__).tap do |lib_dir|
  $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
end

require 'helpers/recurse_directory'

module Puppet::Parser::Functions
  # expects an args containing:
  # args[0]
  # - The source module and directory inside of templates
  # - We will insert templates/ after the module name in this code
  # - required: true
  #
  # args[1]
  # - The destination directory for the interpolated templates to
  # - go on the client machine
  # - required: true
  #
  # args[2]
  # - The file mode for the finished files on the client
  # - required: false
  # - default: 0600
  #
  # args[3]
  # - The owner of the file
  # - required: false
  # - default: owner of puppet running process
  #
  # args[4]
  # - The group ownership of the file
  # - required: false
  # - default: owner of puppet running process
  #
  # args[5]
  # - The file mode for directories
  # - required: false
  # - default: 0700
  newfunction(:recurse_directory, :type => :rvalue) do |args|
    args = (args + [nil] * 5)[0, 6]
    files = Helpers::RecurseDirectory.new(self, compiler.environment, *args).recurse
    files.each do |file, params|
      if function_defined_with_params(["file[#{file}]", params])
        Puppet.debug("Resource file[#{file}] with params #{params} not created because it already exists")
      else
        Puppet.debug("Create new resource file[#{file}] with params #{params}")
        function_create_resources(["File", { file => params }])
      end
    end
    true
  end

  def create_resources(files)
    files.each do |file, params|
      if function_defined_with_params(["file[#{file}]", params])
        Puppet.debug("Resource file[#{file}] with params #{params} not created because it already exists")
      else
        Puppet.debug("Create new resource file[#{file}] with params #{params}")
        function_create_resources(["File", { file => params }])
      end
    end
  end
end
