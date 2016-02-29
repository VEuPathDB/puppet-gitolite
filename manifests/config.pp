# Private class
class gitolite::config inherits gitolite {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { "${gitolite::home_dir}/admin.pub":
    ensure  => file,
    source  => $gitolite::admin_key_source,
    content => $gitolite::admin_key_content,
    owner   => $gitolite::user_name,
    group   => $gitolite::group_name,
    mode    => '0400',
  }->
  exec { "${gitolite::params::cmd_install} admin.pub":
    path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    user        => $gitolite::user_name,
    cwd         => $gitolite::home_dir,
    environment => "HOME=${gitolite::home_dir}",
    creates     => "${gitolite::home_dir}/projects.list",
    before      => File[ "${gitolite::home_dir}/.gitolite.rc" ],
  }

  file { "${gitolite::home_dir}/.gitolite.rc":
    ensure  => file,
    content => template("${module_name}/${gitolite::package_name}.rc.erb"),
    owner   => $gitolite::user_name,
    group   => $gitolite::group_name,
  }
}
