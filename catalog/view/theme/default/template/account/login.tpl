<?php echo $header; ?>
<style>
  .signFaceBook{ text-align: center; border-bottom: 1px solid #ccc; margin: 0px 0px 20px 0px; padding-bottom: 10px;}
  .signFaceBook span {  margin-right: 10px;  font-size: 18px;  line-height: 38px;}
  #loginFaceBook {  display:inline-block;  background-color:#4a67a2;  border: 0px solid #4a67a2;  padding:0 15px 0 40px;  color:#fff;  font-size:16px;  *zoom:1;  margin-left:10px;  text-transform: none;line-height: 38px;  }
  #loginFaceBook i {  display:inline;  font-size: 24px;  float:left;  margin:7px 8px 0 -37px;  width:35px;  height:25px;  border-right:1px solid #e4e4e4  }
</style>
<div class="container">
  <ul class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
    <?php } ?>
  </ul>
  <?php if ($success) { ?>
  <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?></div>
  <?php } ?>
  <?php if ($error_warning) { ?>
  <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="clearfix" style="clear: both">
    <div class=" clearfix">
      <div class="row signFaceBook ">
        <span>Welcome to Kallaworld, Use Your Account from</span>
        <a href="javascript:fblogin(0);" id="loginFaceBook" class="btn btn"><i class="fa fa-facebook"></i> Connect  with  FaceBook</a>
      </div>
    </div>
  </div>
  <div class="row"><?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>
      <div class="row">
        <div class="col-sm-6">
          <div class="well">
            <h2><?php echo $text_new_customer; ?></h2>
            <p><strong><?php echo $text_register; ?></strong></p>
            <p><?php echo $text_register_account; ?></p>
            <a href="<?php echo $register; ?>" class="btn btn-primary"><?php echo $button_continue; ?></a></div>
        </div>
        <div class="col-sm-6">
          <div class="well">
            <h2><?php echo $text_returning_customer; ?></h2>
            <p><strong><?php echo $text_i_am_returning_customer; ?></strong></p>
            <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data">
              <div class="form-group">
                <label class="control-label" for="input-email"><?php echo $entry_email; ?></label>
                <input type="text" name="email" value="<?php echo $email; ?>" placeholder="<?php echo $entry_email; ?>" id="input-email" class="form-control" />
              </div>
              <div class="form-group">
                <label class="control-label" for="input-password"><?php echo $entry_password; ?></label>
                <input type="password" name="password" value="<?php echo $password; ?>" placeholder="<?php echo $entry_password; ?>" id="input-password" class="form-control" />
                <a href="<?php echo $forgotten; ?>"><?php echo $text_forgotten; ?></a></div>
              <input type="submit" value="<?php echo $button_login; ?>" class="btn btn-primary" />
              <?php if ($redirect) { ?>
              <input type="hidden" name="redirect" value="<?php echo $redirect; ?>" />
              <?php } ?>
            </form>
          </div>
        </div>
      </div>
      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<?php echo $footer; ?>

<div class="modal fade" id="loading-modal-dialog" style="top:230px;">
  <div class="modal-dialog" style=" text-align: center">
    <img src="<?=HTTPS_SERVER;?>image/loading.gif">
  </div>
</div>
<script>
  function fblogin(){
    FB.login(fbloginCallback, { scope: "public_profile,email" });
  }
  function fbloginCallback(response){
    var userId = response.authResponse.userID;
    if(response && response.status == 'connected'){
      $('#loading-modal-dialog').modal({'backdrop':'static','show':true});
      FB.api('/me?fields=name,email,first_name,last_name', function(user) {
        if(typeof(user.email)=="undefined"){
          user.email = '';
        }
        user.uid = userId;
        var url = '<?=HTTPS_SERVER;?>?route=account/fblogin/validate';
        $.post(url,user,function(res){
          if(res.status == '01'){
            $('#loading-modal-dialog').modal('hide');
            window.location.href = decodeURI(res.url);
          }
          else{
            $('#loading-modal-dialog').modal('hide');
            window.location.reload();
          }
        },'json').error(function(){
          $('#loading-modal-dialog').modal('hide');
          window.location.reload();
        });
      });
    }
  }
</script>
<script>
  window.fbAsyncInit = function() {
    FB.init({
      appId      : '',
      cookie     : true,
      xfbml      : true,
      version    : 'v2.10'
    });
    FB.AppEvents.logPageView();
  };

  (function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
      js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));
</script>