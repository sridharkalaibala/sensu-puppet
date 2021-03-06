# = Class: sensu::api::config
#
# Sets the Sensu API config
#
class sensu::api::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::purge_config_real and !$sensu::server_real and !$sensu::api_real and !$sensu::dashboard_real {
    $ensure = 'absent'
  } else {
    $ensure = 'present'
  }

  file { '/etc/sensu/conf.d/api.json':
    ensure  => $ensure,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0444',
  }

  sensu_api_config { $::fqdn:
    ensure  => $ensure,
    host    => $sensu::api_host,
    port    => $sensu::api_port,
  }

}
