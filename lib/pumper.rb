module Command
  autoload :BaseCommand,                'command/base_command'
  autoload :GemUninstallCommand,        'command/gem_uninstall_command'
  autoload :GemRebuildCommand,          'command/gem_rebuild_command'
  autoload :GemInstallCommand,          'command/gem_install_command'
  autoload :GemInstallToVendorCommand,  'command/gem_install_to_vendor_command'
  autoload :StashGemfileLockCommand,    'command/stash_gemfile_lock_command'
  autoload :Repository,                 'command/repository'
end

module Pumper
  autoload :Configuration,     'pumper/configuration'
  autoload :Specification,     'pumper/specification'
  autoload :Project,           'pumper/project'
  autoload :Pump,              'pumper/pump'
end

