//= require jquery

(function() {

	var form = $('#form-reset');

	form.submit(function() {

		var password = $('#password'),
			verify = $('#verify-password');

		if (password.val() != verify.val()) {

			var flash = $('#flash');

			if (flash.size() < 1) {
				flash = $('<div id="flash"/>');
				$('#reset').after(flash);
			}

			flash.html('<div class="alert alert-error">Password doesn\'t match confirmation.</div>');

			return false;
		}
	});

}());
