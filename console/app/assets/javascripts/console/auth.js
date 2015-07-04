//= require jquery

(function() {
	var validation = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
	var forgot = $('#forgot');

	forgot.on('click', function(ev) {

		ev.preventDefault();
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
			var reset_form = form.clone();
			$('#password', reset_form).remove();
			reset_form.attr('action', forgot.attr('href'));
			reset_form.submit();
		}

		return false;
	});
}());
