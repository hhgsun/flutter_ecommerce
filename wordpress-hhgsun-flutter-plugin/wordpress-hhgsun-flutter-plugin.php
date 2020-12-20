<?php
/**
 * @package HHGSUN PLUGIN FOR FLUTTER
 */
/*
Plugin Name: HHGsun Support Rest Api for Flutter
Plugin URI: https://hhgsun.wordpress.com/
Description: HHGSUN:Flutter uygulamasına woocommerce sistemini entegre ederken yardımcı olmaya çalışacak eklenti
Version: 1.0.0
Author: HHGsun
Author URI: https://hhgsun.wordpress.com/
License: GPLv2 or later
Text Domain: hhgsun

WC requires at least: 4.8.0
WC tested up to: 4.8.0

*/

// {domain}/wp-json/hhgsun/v1/author/1

// https://github.com/woocommerce/woocommerce-gutenberg-products-block/blob/a404e5b24814240f15e50aa4f983b787bb9b36f1/src/StoreApi/docs/nonce-tokens.md

//add_filter( 'woocommerce_store_api_disable_nonce_check', '__return_true' );

if ( ! defined( 'ABSPATH' ) ) {
  exit; // Exit if accessed directly
}

$custom_restapi_requests = array(
  new RequestRestApiModel(
    "/create-store-nonce", "GET",
    'kullaniciya sepet için nonce key döner (return: "b76....350")',
    function($req) {
      return wp_create_nonce( 'X-CoCart-API' ); // wp_create_nonce( 'wc_store_api' );
    },
  ),
  new RequestRestApiModel(
    "/user/favorites", "GET",
    "userid kullanıcısının favorileri (request: ?userid=999) (return: [list:id])",
    function($req) {
      if($req['userid'] == null)
        return array('success' => false, 'data' => "userid olmalıdır");
      $userid = $req['userid'];
      $favorite_products = get_user_meta( $userid, 'favorite_products', true );
      return array('success' => true, 'data' => $favorite_products);
    },
  ),
  new RequestRestApiModel(
    "/user/favorites/delete", "POST",
    "userid kullanıcısının favorilerinden bir ürün çıkarır (request: ?userid=999&productid=999) (return: boolean)",
    function($req) {
      if($req['userid'] == null)
        return array('success' => false, 'data' => "userid olmalıdır");
      if($req['productid'] == null)
        return array('success' => false, 'data' => "productid olmalıdır");
      $userid = $req['userid'];
      $productid = $req['productid'];
      $favorite_products = get_user_meta( $userid, 'favorite_products', true );
      if(is_array($favorite_products)) {
        if( in_array($productid, $favorite_products) ) {
          $index = array_search($productid, $favorite_products);
          unset($favorite_products[$index]);
          update_user_meta( $userid, 'favorite_products', $favorite_products );
          return array('success' => true, 'data' => 'ürün favorilerinizden kaldırıldı');
        }
      }
      return array('success' => false, 'data' => 'ürün favorinizde yok');
    },
  ),
  new RequestRestApiModel(
    "/user/favorites/add", "POST",
    "userid kullanıcısının favorilerine yeni ürün ekleme (request: ?userid=999&productid=999) (return: boolean)",
    function($req) {
      if($req['userid'] == null)
        return array('success' => false, 'data' => "userid olmalıdır");
      if($req['productid'] == null)
        return array('success' => false, 'data' => "productid olmalıdır");
      $userid = $req['userid'];
      $productid = $req['productid'];
      $favorite_products = get_user_meta( $userid, 'favorite_products', true );
      if(is_array($favorite_products)) {
        if( in_array($productid, $favorite_products) ) {
          return array('success' => false, 'data' => 'ürün daha önce eklenmiş');
        }
      } else {
        $favorite_products = array();
      }
      $favorite_products[] = $productid;
      update_user_meta( $userid, 'favorite_products', $favorite_products );
      return array('success' => true, 'data' => 'ürün favorilerinize eklendi');
    },
  ),
  //
  new RequestRestApiModel(
    "/lost/password", "POST",
    "email adresine şifre yenileme linki gönderir (request: ?email=name@mail.com) (return: boolean)",
    function($req) {
      if($req['email'] == null)
        return array('success' => false, 'data' => "Lütfen E-mail adresinizi giriniz");
      $email = $req['email'];
      $userdata = get_user_by( 'email', $email);
      if ( empty( $userdata ) ) {
          return array('success' => false, 'data' => "Bu e-posta adresine kayıtlı kullanıcı bulunamadı");
      }
      $user      = new WP_User( intval( $userdata->ID ) ); 
      $reset_key = get_password_reset_key( $user );
      $wc_emails = WC()->mailer()->get_emails();
      $wc_emails['WC_Email_Customer_Reset_Password']->trigger( $user->user_login, $reset_key );
      return array('success' => true, 'data' => "Şifre sıfırlama bağlantısı kayıtlı e-posta adresinize gönderildi");
    },
  ),
  
  /* new RequestRestApiModel(
    "/favorites/(?P<id>\d+)", "GET",
    "Favorilere eklenen ürünleri geri döner",
    function($req) {
      $data = array( 'kullanıcıya ait favori ilanlar', $req );
      return array('success' => true, 'data' => $data);
    },
  ), */
);

class RequestRestApiModel {
  public $endpoint;
  public $method;
  public $description;
  public $callback;
  public function __construct($endpoint, $method, $description, $callback) {
    $this->endpoint = $endpoint;
    $this->method = $method;
    $this->description = $description;
    $this->callback = $callback;
  }
}

class SupportRestApiForFlutter {

  public $pluginTitle = "HHGsun Support Rest Api for Flutter";
  public $pluginSlug = "hhgsun-rest-api-flutter";
  public $disabledPluginsCount = 0;
  public $requiredPlugins = array(
    array("woocommerce", "woocommerce.php", "automattic"),
    array("jwt-authentication-for-wp-rest-api", "jwt-auth.php", "Enrique Chavez"),
    array("cart-rest-api-for-woocommerce", "cart-rest-api-for-woocommerce.php", "CoCart Lite - Sébastien Dumont"),
  ); // folder, file.php, Author

  public $nameSpaceRoute = "hhgsun/v1";
  public $custom_request_endpoints = array();

  function __construct($listReqModel) {
    $this->custom_request_endpoints = $listReqModel;
  }

  function restApiInit() {
    foreach ($this->custom_request_endpoints as $key => $req) {
      register_rest_route( $this->nameSpaceRoute, $req->endpoint, array(
        'methods' => $req->method,
        'callback' => $req->callback,
        'permission_callback' => '__return_true',
      ));
    }
  }

  function init(){
    add_action( 'rest_api_init', array($this, "restApiInit") );
    if(is_admin()){
      add_action('admin_menu', array($this, "dash_menu_add_custom_page"));
      // plugins check active
      add_action('admin_notices', array($this, "pluginCheckActive"));
      add_filter('plugin_action_links_'.plugin_basename(__FILE__), array($this, 'hhg_add_plugin_page_settings_link'));
    }
  }

  function urlPluginSettingPage() {
    return admin_url( 'options-general.php?page=' .$this->pluginSlug );
  }

  function hhg_add_plugin_page_settings_link( $links ) {
    $links[] = '<a href="' . $this->urlPluginSettingPage() . '">' . __('Settings') . '</a>';
    return $links;
  }

  function pluginCheckActive() {
    if($this->requiredPlugins) {
      foreach ($this->requiredPlugins as $key => $value) {
        if (!is_plugin_active($value[0]. '/' .$value[1])) {
          $this->disabledPluginsCount++;
          echo '<div class="error notice">';
          echo '<p><b>'. $value[0] .'</b> ('. $value[2] .') eklentisi AKTİF DEĞİL veya EKLENMEMİŞ';
          echo '<a href="'. $this->urlPluginSettingPage() .'" style="text-decoration:none;margin-left:15px;">'. '<span class="dashicons dashicons-hammer"></span>' .'</a></p>';
          echo '</div>';
        }
      }
    }
  }

  /**
   * 
   * Custom plugin page
   * 
   */
  function dash_menu_add_custom_page() {
    //add_menu_page($this->pluginTitle, $this->pluginTitle, "delete_posts", $this->pluginSlug, array($this, 'theme_setting_page_render') , 'dashicons-hammer', 80 );
    add_submenu_page(
      "options-general.php",
      $this->pluginTitle,
      $this->pluginTitle,
      "delete_posts",
      $this->pluginSlug,
      array($this, 'theme_setting_page_render'),
      1
    );
    add_action( 'admin_init', array($this, 'register_plugin_custom_settings') );
    add_action( "admin_enqueue_scripts", function(){
      wp_enqueue_script('jquery-ui-sortable');
    } );
  }
  
  function register_plugin_custom_settings() {
    register_setting( 'theme_settings_group_data', 'setting_extracode' );
    register_setting( 'theme_settings_group_data', 'setting_all_socialmedia' );
    register_setting( 'theme_settings_group_data', 'setting_footer_desc' );
    register_setting( 'theme_settings_group_data', 'setting_yapim_asamasinda' );
    register_setting( 'theme_settings_group_data', 'setting_yapim_asamasinda_url' );
  }

  function theme_setting_page_render() { ?>
    <style>
      details {
        border: 1px solid #dddddd;
        border-radius: 0.25rem;
        margin:10px 0;
      }
      details summary {
        font-size: 1rem;
        color: gray;
        cursor: pointer;
        padding: 10px;
      }
      details section {
        padding: 15px;
        border-top: 1px dashed #dddddd;
      }
      details section {
        display:flex;
        flex-wrap: wrap;
        align-items: center;
      }
      details section h3 {
        margin-bottom: 10px;
        flex: 100%;
      }
      details section small {
        color:gray;
      }
      details section input, details section select, details section textarea{
        display:block;
      }
      input[type=color] {
        display:inline-block;
      }
      .ui-state-highlight {
        background:#dedede;
      }
      .clear-flex{
        flex:100%;
      }
    </style>
    <div class="wrap">

      <h1><?php echo $this->pluginTitle; ?></h1>
  
      <?php
        if($this->requiredPlugins) {
          foreach ($this->requiredPlugins as $key => $value) {
            $isActive = is_plugin_active($value[0]. '/' .$value[1]);
            if ($isActive) {
              echo '<p><b>'. $value[0] .'</b> ('. $value[2] .') AKTİF <span class="dashicons dashicons-saved"></span> </p>';
            } else {
              echo '<p><b>'. $value[0] .'</b> ('. $value[2] .') AKTİF DEĞİL <span class="dashicons dashicons-warning" style="color:#dc3232;"></span> </p>';
            }
          }
        }

        if($this->disabledPluginsCount > 0) {
          echo "<p><strong>Lütfen yukarıdaki eklentileri menüdeki eklentiler bölümünden isimlerini aratıp kurun ve aktif edin</strong></p>";
        }
      ?>

      <form class="theme-dash" method="post" action="options.php">
        <?php 
        settings_fields( 'theme_settings_group_data' );
        do_settings_sections( 'theme_settings_group_data' );
        ?>
  
        <details>
          <summary>Sosyal Medya Hesapları</summary>
          <section>
            <div id="social_media_links_wrap">
              <?php if(get_option('setting_all_socialmedia')) {
                foreach (get_option('setting_all_socialmedia') as $key => $value) { ?>
                <section class="ui-sortable-handle">
                  <span class="move-btn dashicons dashicons-sort"></span>
                  <input type="text" name="setting_all_socialmedia[<?php echo $key; ?>][title]" value="<?php echo esc_attr( $value['title'] ); ?>" placeholder="Sosyal medya başlık" />
                  <input type="text" name="setting_all_socialmedia[<?php echo $key; ?>][icon]" value="<?php echo esc_attr( $value['icon'] ); ?>" placeholder="İcon kodu" />
                  <input type="text" name="setting_all_socialmedia[<?php echo $key; ?>][link]" value="<?php echo esc_attr( $value['link'] ); ?>" placeholder="Sosyal medya link" />
                  <span class="btn_delete_social_media"><span class="dashicons dashicons-trash"></span></span>
                </section>
              <?php } } ?>
            </div><!-- #social_media_links_wrap -->
          </section>
          <section>
            <button type="button" class="button btn-social-media-new">Yeni Ekle</button>
          </section>
          <div style="padding:20px;">
            <small> icon seti: https://fontawesome.com/icons?m=free, </small><br>
            <small> icon <code>&lt;i class="fab fa-facebook-square"&gt;&lt;/i&gt;</code>, </small><br>
            <small> link <code>http://socialmedia.com/hesap</code></small>
          </div>
        </details><!-- .sosyal medya -->
  
        <details>
          <summary>Site Alt Alan</summary>
          <section>
            Sitenin alt kısmında gözükecek yazı(html) girebilirsiniz
            <textarea rows="4" cols="50" name="setting_footer_desc" style="width:80%;" placeholder="yazı veya html içerik"><?php echo esc_attr( get_option('setting_footer_desc') ); ?></textarea>
          </section>
        </details><!-- .footer açıklama -->
  
        <details>
          <summary>Ekstra Kod</summary>
          <section>
            Header içi Kod
            <textarea rows="4" cols="50" name="setting_extracode[head]" style="width:80%;" placeholder="header'a javascript veya css kodu"><?php echo esc_attr( get_option('setting_extracode')['head'] ); ?></textarea>
          </section>
          <section>
            Footer içi Kod
            <textarea rows="4" cols="50" name="setting_extracode[foot]" style="width:80%;" placeholder="footer'a javascript veya css kodu"><?php echo esc_attr( get_option('setting_extracode')['foot'] ); ?></textarea>
            <div style="margin:10px 0;">
              <code>ilgili alanlara kod satırları eklenebilir; css ve js özel değişiklikler yapılabilir veya Google Analytics gibi özel kod bloğu eklenebilir</code>
              <br>
              <code>&lt;style&gt;body{background:red;}&lt;/style&gt;</code><br>
              <code>&lt;script&gt;alert('Hoşgeldiniz...');&lt;/script&gt;</code>
            </div>
          </section>
        </details><!-- .ekstra kod  -->
  
        <details>
          <summary>Diğer Ayarlar</summary>
          <section>
            <label for="yapimda" style="margin-right:5px;">Site Yapım Aşamasında</label>
            <input type="checkbox" id="yapimda" name="setting_yapim_asamasinda" value="1" <?php echo get_option('setting_yapim_asamasinda') ? 'checked' : ''; ?> />
            <input type="text" id="yapimda_url" name="setting_yapim_asamasinda_url" value="<?php echo esc_attr( get_option('setting_yapim_asamasinda_url') ); ?>" placeholder="Yönlenecek Url" />
          </section>
        </details><!-- .diğer ayarlar  -->
  
        <div class="theme-dash-savebtn"><?php submit_button(); ?></div>
      </form>

      <h2>Custom Endpoints</h2>
      <?php
      if(isset( $this->custom_request_endpoints )) {
        foreach ($this->custom_request_endpoints as $key => $custom_req) {
          echo $custom_req->method . ' ' . get_site_url() . '/wp-json/' . $this->nameSpaceRoute . '<b>' . $custom_req->endpoint. '</b><br>';
          echo $custom_req->description . '<hr>';
        }
      }
      ?>

    </div><!-- /.wrap -->
  
    <script>
      jQuery(document).ready(function($){
        // Social Media ////////////////////////////////////
        $( "#social_media_links_wrap" ).sortable({ placeholder: "ui-state-highlight" });
        $( "#social_media_links_wrap" ).disableSelection();
        $('.btn-social-media-new').click(function(){
          var keyItem = Date.now();
          $('#social_media_links_wrap').append(
            '<section class="ui-sortable-handle">'
              +' <span class="move-btn dashicons dashicons-sort"></span> '
              +' <input type="text" name="setting_all_socialmedia['+ keyItem +'][title]" value="" placeholder="sosyal medya başlık" /> '
              +' <input type="text" name="setting_all_socialmedia['+ keyItem +'][icon]" value="" placeholder="icon kodu" /> '
              +' <input type="text" name="setting_all_socialmedia['+ keyItem +'][link]" value="" placeholder="sosyal medya link" /> '
              +' <span class="btn_delete_social_media"><span class="dashicons dashicons-trash"></span></span>'
            +'</section>'
          );
        });
        $(document).on('click', '.btn_delete_social_media', function(){
          var sor = confirm('Kaldırmak istediğinize eminmisiniz?');
          if(sor){
            var itemParent = $(this).parent()[0];
            itemParent.remove();
          }
        });
  
        // Kategori Gösterimi ////////////////////////////////////
        $( "#home_cat_show_wrap" ).sortable({ placeholder: "ui-state-highlight" });
        $( "#home_cat_show_wrap" ).disableSelection();
        $('.btn-home-cat-new').click(function(){
          var keyItem = Date.now();
          $('#home_cat_show_wrap').append(
            '<section class="ui-sortable-handle">'
              +' <span class="move-btn dashicons dashicons-sort"></span> '
              +' <input type="text" name="setting_home_cat_show['+ keyItem +'][title]" value="" placeholder="Başlık" /> '
              +' <input type="text" name="setting_home_cat_show['+ keyItem +'][img]" value="" placeholder="Resim Url" /> '
              +' <input type="text" name="setting_home_cat_show['+ keyItem +'][url]" value="" placeholder="Link Url" /> '
              +' <span class="btn_delete_social_media"><span class="dashicons dashicons-trash"></span></span>'
            +'</section>'
          );
        });
        $(document).on('click', '.btn_delete_homecat', function(){
          var sor = confirm('Kaldırmak istediğinize eminmisiniz?');
          if(sor){
            var itemParent = $(this).parent()[0];
            itemParent.remove();
          }
        });
  
      });
    </script>
  
  <?php 
  }


}

$sraff = new SupportRestApiForFlutter($custom_restapi_requests);
$sraff->init();
