# = Class: sensu::server::service
#
# Manages the Sensu server service
#
class sensu::server::service {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::manage_services_real {

    case $sensu::server_real {
      true: {
        $ensure = 'running'
        $enable = true
      }
      default: {
        $ensure = 'stopped'
        $enable = false
      }
    }

    service { 'sensu-server':
      ensure    => $ensure,
      enable    => $enable,
      subscribe => [ Class['sensu::package'], Class['sensu::api::config'], Class['sensu::redis::config'], Class['sensu::rabbitmq::config'] ],
    }
  }
}
