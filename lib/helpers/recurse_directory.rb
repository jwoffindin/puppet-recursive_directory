module Helpers
  FIELDS = [:source_dir, :destination_dir, :file_mode, :file_owner, :file_group, :dir_mode]

  # Implementation of recurse_directory puppet function. This is invoked directly from
  # the puppet function ./lib/puppet/parser/functions/recurse_directory.rb
  class RecurseDirectory < Struct.new(:template_context, *FIELDS)
    def initialize(*args)
      super
      self.file_mode = '0600' unless file_mode && file_mode != ''
      self.dir_mode  = '0700' unless dir_mode && dir_mode != ''
    end

    def recurse
      creatable_resources = []
      template_root.find do |path|
        next if path == template_root
        relative_path = path.relative_path_from(template_root)
        creatable_resources << entry_to_resource(path, relative_path)
      end
      Hash[creatable_resources.compact]
    end

    private

    def template_root
      @template_root ||= build_template_root
    end

    def entry_to_resource(path, relative_path)
      if File.file?(path)
        resource_path = "#{destination_dir}/#{relative_path.to_s.gsub(/\.erb$/, '')}"
        [resource_path, file_resource(path)]
      elsif File.directory?(path) && relative_path != '.' && relative_path != '..'
        ["#{destination_dir}/#{relative_path}", directory_resource(path)]
      end
    end

    def file_resource(path)
      {
        'ensure'  => 'file',
        'content' => process_template_file(template_context, path),
        'owner'   => file_owner,
        'group'   => file_group,
        'mode'    => file_mode
      }.reject { |_, v| v.nil? }
    end

    def directory_resource(_path)
      {
        'ensure' => 'directory',
        'owner'  => file_owner,
        'group'  => file_group,
        'mode'   => dir_mode
      }.reject { |_, v| v.nil? }
    end

    def build_template_root
      module_name, template_path = source_dir.split(File::Separator, 2)
      file_path = File.join([module_dir, module_name, 'templates', template_path].compact)
      Pathname.new(file_path)
    end

    def module_dir
      Puppet[:modulepath].split(File::PATH_SEPARATOR).first
    end

    def process_template_file(template_context, file)
      wrapper = Puppet::Parser::TemplateWrapper.new(template_context)
      wrapper.file = file.to_s
      wrapper.result
    rescue => ex
      raise Puppet::ParseError, describe_template_failure(ex)
    end

    def describe_template_failure(ex)
      path, line_no = ex.backtrace.first.split(':', 2)
      format("Failed to parse template %s:\n  Filepath: %s\n  Line: %s\n  Detail: %s\n", file, path, line_no, ex)
    end
  end
end
