//= require jquery

(function() {
	var validation = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
	var forgot = $('#forgot');

	forgot.click(function() {

		var form = $('#form-authentication'),
			login = $('#login'),
			flashes = $('#flash');			

		if (!validation.test(login.val())) {
			if (flashes.size() < 1) {
				flashes = $('<div id="flash" />');
				$('#signin').after(flashes);
			}

			flashes.html('<div class="alert alert-error">Empty or invalid e-mail. Please complete with your account e-mail to reset your password.</div>');

			return false;
		} else {
			flashes.fadeOut();
			form.attr('action', forgot.attr('href')).submit();
		}

		return false;
	});
}());
