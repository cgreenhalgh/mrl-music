CREATE DATABASE `wp-bcm`
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

-- bcm wordpress mysql account
CREATE USER 'wp-bcm' IDENTIFIED WITH mysql_native_password BY 'XXXX';
GRANT ALL PRIVILEGES ON `wp-bcm`.* TO 'wp-bcm';

