(function($) {
'use strict';

var toggle_controls = function(query, enable) {
	$(query).prop('disabled', !enable);
};

var enable_pj_controls = function () {
	toggle_controls('.type-pf-control', false);
	toggle_controls('.type-pj-control', true);
};

var enable_pf_controls = function () {
	toggle_controls('.type-pf-control', true);
	toggle_controls('.type-pj-control', false);
};

var toggle_country = function(country_code) {
	if (country_code == 'BR') {
		$('.br-type-control').removeClass('hidden');
	} else {
		$('.br-type-control').addClass('hidden');
	}
};

$('#is_billing').change(function() {
	toggle_controls('.inputs .controls input',  !this.checked);
	toggle_controls('.inputs .controls select', !this.checked);
	if (!this.checked) {
		if ($('#type_pf')[0].checked) {
			enable_pf_controls();
		} else {
			enable_pj_controls();
		}
	}
});

var is_billing = $('#is_billing');
if (is_billing.length > 0 && is_billing[0].checked) {
	toggle_controls('.inputs .controls input',  false);
	toggle_controls('.inputs .controls select', false);
}

toggle_country($('#country_code').val());
$('#country_code').change(function(el) { toggle_country(this.value); })
$('#type_pf').click(function() { enable_pf_controls(); });
$('#type_pj').click(function() { enable_pj_controls(); });

function ValidarCPF(ObjCpf)
{
	var cpf = ObjCpf.val();
	var exp = /[^0-9]/g;
	cpf = cpf.toString().replace( exp, "" );
	if (cpf == "")
		return true;
	var digitoDigitado = eval(cpf.charAt(9)+cpf.charAt(10));
	var soma1=0, soma2=0;
	var vlr = 11;

	for(var i=0;i<9;i++){
		soma1+=eval(cpf.charAt(i)*(vlr-1));
		soma2+=eval(cpf.charAt(i)*vlr);
		vlr--;
	}
	soma1 = (((soma1*10)%11)==10 ? 0:((soma1*10)%11));
	soma2=(((soma2+(2*soma1))*10)%11);

	var digitoGerado=(soma1*10)+soma2;
	return digitoGerado == digitoDigitado;
}

function ValidarCNPJ(ObjCnpj)
{
	var cnpj = ObjCnpj.val();
	var valida = new Array(6,5,4,3,2,9,8,7,6,5,4,3,2);
	var dig1 = new Number;
	var dig2 = new Number;

	var exp = /[^0-9]/g;
	cnpj = cnpj.toString().replace( exp, "" );
	if (cnpj == "")
		return true;
	var digito = new Number(eval(cnpj.charAt(12)+cnpj.charAt(13)));

	for(var i = 0; i<valida.length; i++){
		dig1 += (i>0? (cnpj.charAt(i-1)*valida[i]):0);
		dig2 += cnpj.charAt(i)*valida[i];
	}
	dig1 = (((dig1%11)<2)? 0:(11-(dig1%11)));
	dig2 = (((dig2%11)<2)? 0:(11-(dig2%11)));

	return ((dig1*10)+dig2) == digito;
}

$('#pf_cpf').mask('999.999.999/99');
$('#pj_cnpj').mask('99.999.999/9999-99');

$('.form-address').submit(function(ev) {
	if (!ValidarCPF($('#pf_cpf'))) {
		alert('CPF Inválido!');
		$('#pf_cpf').focus();
		return false;
	}

	if (!ValidarCNPJ($('#pj_cnpj'))) {
		alert('CNPJ Inválido!');
		$('#pj_cnpj').focus();
		return false;
	}
	return true;
});


}(jQuery));
