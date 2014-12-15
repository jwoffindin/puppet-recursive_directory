# puppet-recursive_directory

Puppet module to allow for files to be created recursively from a folder of templates

The benefit here is that you no longer need to define file resources for each
and every template file

This should help to substantially shorten manifests that include lots of
template files

## Usage

    recursive_directory {'some_unique_title':
          source_dir => 'custom_module/source_dir',
          dest_dir   => '/tmp',
          file_mode  => '0644',
          owner      => 'root',
          group      => 'root',
          dir_mode   => '0700',
    }

This will copy all files from `<module_path>custom_module/templates/source_dir`
folder and interpolate variables the same as when using the `template()`
function inside of the manifest itself and put them into `/tmp`

## Parameters

<dl>
  <dt>source_dir</dt>
  <dd>
    The module_name followed by a subfolder inside of <module_name>/templates If
    source_dir is simply the modulename, recursive_directory will interpolate
    and create file resources for all files in <module_name> <em>required</em>
  </dd>

  <dt>dest_dir</dt>
  <dd>
    The fully qualified path on the client system where the interpolated
    templates and files should be created *required*
  </dd>

  <dt>file_mode</dt>
  <dd>
    The file mode for all of the files. <em>required</em>.
    <em>default: 0600</em>
  </dd>

  <dt>dir_mode</dt>
  <dd>
    The file mode for all of the directories. <em>required</em>.
    <em>default: 0700</em>
  </dd>

  <dt>owner</dt>
  <dd>The owner of the file. <em>default: 'nobody'</em></dd>

  <dt>group</dt>
  <dd>The group of the file. <em>default: 'nobody'</em></dd>
</dl>

## Testing

rake spec in the root checkout of the module

    $ bundle install
    $ bundle exec rake spec
