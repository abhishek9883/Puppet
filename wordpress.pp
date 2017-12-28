package {'apache2':
ensure => present,
}
service {'apache2':
ensure => running,
}
exec {'apt-get update':
path => '/usr/bin/',
before => Package['apache2'],
}
package {'mysql-server':
ensure => present,
require => Service['apache2'],
}
->
service {'mysql':
ensure => running,
}
package {'php5':
ensure => present,
}
file {'/var/www/html/info.php':
ensure => present,
content => '<?php phpinfo(); ?>',
}
package {'php5-mysql':
ensure => present,
require => Package['php5'],
}
package {'libapache2-mod-php5':
ensure => present,
}
package {'php5-mcrypt':
ensure => present,
}
package {'php5-gd':
ensure => present,
}
package {'libssh2-php':
ensure => present,
}
exec {'mysqladmin -u root password 123@India && touch /var/flagmysql':
path => '/usr/bin',
creates => '/var/flagmysql',
}
file {'/tmp/mysqlcommand':
ensure => present,
source => '/var/mysqlcommand',
}
->
exec {'wget http://wordpress.org/latest.tar.gz':
cwd => '/root/puppetcode',
path => '/usr/bin',
creates => '/root/puppetcode/latest.tar.gz',
}
->
exec {'tar xzvf latest.tar.gz':
cwd => '/root/puppetcode',
path => '/bin/',
}
->
file {'/var/www/html/wp-config.php':
ensure => present,
source => '/root/puppetcode/wp-config-sample.php',
}
->
exec {'cp -R /root/puppetcode/wordpress/* /var/www/html/':
path => '/bin',
creates => '/var/www/html/wp-cron.php',
}
->
exec {'chown -R www-data:www-data *':
cwd => '/var/www/html',
path => '/bin',
}
->
exec {'mkdir /var/www/html/wp-content/uploads && touch /var/flagmkdir':
path => '/bin',
creates => '/var/flagmkdir',
}
->
exec {'chown -R :www-data /var/www/html/wp-content/uploads':
path => '/bin/',
}

