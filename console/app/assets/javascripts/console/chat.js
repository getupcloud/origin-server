if (location.hostname === "broker.getupcloud.com") {
  window.$zopim || (function(d,s){var z=$zopim=function(c){z._.push(c)},$=z.s=d.createElement(s),e=d.getElementsByTagName(s)[0];z.set=function(o){z.set._.push(o)};z._=[];z.set._=[];$.async=!0;$.setAttribute('charset','utf-8'); $.src='//v2.zopim.com/?1aNSsavBi1e9Gs5y9Olsh4R2HJYYQFNP';z.t=+new Date; $.type='text/javascript';e.parentNode.insertBefore($,e)})(document,'script');

  $zopim(function() {
    var name = $('#userinfo_name');
    if ((!$zopim.livechat.getName()) && name.length) {
      $zopim.livechat.setName(name.val());
    }

    var email = $('#userinfo_email');
    if ((!$zopim.livechat.getEmail()) && email.length) {
      $zopim.livechat.setEmail(email.val());
    }
  });
}
