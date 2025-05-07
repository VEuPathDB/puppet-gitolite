# == Class: gitolite
#
class gitolite (
  Optional[String] $admin_key_content     = $gitolite::params::admin_key_content,
  Optional[String] $admin_key_source      = $gitolite::params::admin_key_source,
  Boolean $allow_local_code               = $gitolite::params::allow_local_code,
  String $git_config_keys                 = $gitolite::params::git_config_keys,
  String $group_name                      = $gitolite::params::group_name,
  Stdlib::Absolutepath $home_dir          = $gitolite::params::home_dir,
  Boolean $local_code_in_repo             = $gitolite::params::local_code_in_repo,
  String $local_code_path                 = $gitolite::params::local_code_path,
  Boolean $manage_home_dir                = $gitolite::params::manage_home_dir,
  Boolean $manage_user                    = $gitolite::params::manage_user,
  Stdlib::Ensure::Package $package_ensure = $gitolite::params::package_ensure,
  String $package_name                    = $gitolite::params::package_name,
  Boolean $repo_specific_hooks            = $gitolite::params::repo_specific_hooks,
  Pattern[/^0[0-7][0-7][0-7]$/] $umask    = $gitolite::params::umask,
  String $user_name                       = $gitolite::params::user_name,
  Enum['2', '3'] $version                 = $gitolite::params::version,
) inherits gitolite::params {

  if $admin_key_source and $admin_key_content {
    fail 'Parameters `admin_key_source` and `admin_key_content` are mutually exclusive'
  }

  if $local_code_in_repo and ! $allow_local_code {
    fail 'Parameter `allow_local_code` must be true to enable `local_code_in_repo`'
  }

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ->
  anchor { "${module_name}::end": }

}
