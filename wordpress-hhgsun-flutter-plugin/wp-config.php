<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'canliozelders_wpmobil' );

/** MySQL database username */
define( 'DB_USER', 'canliozelders_wpmobil' );

/** MySQL database password */
define( 'DB_PASSWORD', '17SKp]U!(8jxG()7' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'jbxdbbhbuuyvbahjlijcawx2a3lynxseqfc6ec545jctgvamhbkmw71bpl1ew4yj' );
define( 'SECURE_AUTH_KEY',  'v0hvo2j0swvkotudpfepalupead2yo5jo6qihcp1wzero9pajvia49lyai29es2d' );
define( 'LOGGED_IN_KEY',    'gu8pwzjgmfrrkuexhqsvum0pddhdksb8ot7hkrsake9ofnlixku111dcegpiq71a' );
define( 'NONCE_KEY',        '5nmpo0g9fvnpxdgnwqvv1zcdzoxozc9hdswgqxb4fm6vruy8pmfvdyblab71smld' );
define( 'AUTH_SALT',        'tx3abkglvo9xlz4ay8cxhu9xvak5mwhsjluzmdhnpsylfkhwjlgfpldftjp1bxpw' );
define( 'SECURE_AUTH_SALT', 'iu56gm8gzn8gavwooyif4raa4vb15mhvnt6v5zdqmo65s7zqsr6zjpwo2evysmk3' );
define( 'LOGGED_IN_SALT',   'lzgmvqmidmfvs7pqb0nhnbftm61sz6aa0l5zjvnghic4g3xcjw2io7aya2i2mbcw' );
define( 'NONCE_SALT',       'hj9y3rpaxv5jjbyypnmatzza3pwlnzmfyjeagaqtkdjyymd33d8d2al13ghf8bk9' );

/**#@-*/

define('JWT_AUTH_SECRET_KEY', 'hhgsun#woocommerce#flutter'); //HHGSUN

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wphg_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', true );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
