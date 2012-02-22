javascript:( function(){
	var j = document.createElement('script');
	j.charset='UTF-8';
	j.src="http://localhost:3000/js/jquery-1.7.1.min.js";
	document.body.appendChild(j);
	var s = document.createElement('script');
	s.charset='UTF-8';
	s.src='http://localhost:3000/laptimeimporter.js';
	document.body.appendChild(s);
	var f = document.createElement('p');
	f.id = 'setup';
	f.innerHTML = 'foo.htm';
	document.body.appendChild(f);
})();
