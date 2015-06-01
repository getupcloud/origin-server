$(function($) {
	'use strict';

	//
	// Pagar.me
	//
	PagarMe.encryption_key = "ek_test_y5S0NnXEMirqfLoUe1mYwAzLd3VJKZ";

	var $form = $("#payment_form");

	$form.submit(function(event) {
		// inicializa um objeto de cartão de crédito e completa
		// com os dados do form
		var creditCard = new PagarMe.creditCard();
		creditCard.cardHolderName = $("#payment_form #cc_name").val();
		creditCard.cardExpirationMonth = $("#payment_form #cc_exp_month").val();
		creditCard.cardExpirationYear = $("#payment_form #cc_exp_year").val();
		creditCard.cardNumber = $("#payment_form #cc_number").val();
		creditCard.cardCVV = $("#payment_form #cc_cvc").val();

		// pega os erros de validação nos campos do form
		var fieldErrors = creditCard.fieldErrors();

		//Verifica se há erros
		var hasErrors = false;
		for (var field in fieldErrors) { hasErrors = true; break; }

		if (hasErrors) {
			// realiza o tratamento de errors
			alert(fieldErrors);
		} else {
			creditCard.generateHash(function(cardHash) {
				var form = $form.clone();
				$('[name^=cc_]', form).remove();
				form.append($('<input type="hidden" name="card_hash">').val(cardHash));
				form.submit();

				//$('.card-body input[type=text]', form).remove();
				//form.append($('<input type="hidden" name="card_hash">').val(cardHash));
				//form.get(0).submit();
			});
		}

		return false;
	});

});

