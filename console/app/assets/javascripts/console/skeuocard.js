$(function($) {
	'use strict';

	//
	// Skeuocard
	//
	var $skeuocard = $("#skeuocard");
	if ($skeuocard.length == 0) {
		return;
	}

	window.card = new Skeuocard($skeuocard, {
		/*
		debug: true,
		initialValues: {
			number: "4111111111111111",
			expMonth: "1",
			expYear: "2016",
			name: "James Doe",
			cvc: "123"
		},
		*/
		strings: {
			hiddenFaceFillPrompt: "<strong>Clique aqui</strong> para <br>girar o cartão",
			hiddenFaceErrorWarning: "Existe algo errado no outro lado",
			hiddenFaceSwitchPrompt: "Esqueceu algo?<br> Gire o cartão"
		}
	});
});
