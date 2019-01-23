    var csrfParameter = '${_csrf.parameterName}';
    var csrfToken = '${_csrf.token}';    // join to the event
    window.onload = function() {
    	
    	if (window.location.href.indexOf('#_=_') > 0) {
    		window.location = window.location.href.replace(/#.*/, '');
    	}
    }
    function join(id) {
    	var jsonParams = {};
    	jsonParams['eventId'] = id;
    	jsonParams[csrfParameter] = csrfToken;
		$.ajax({
			type : "POST",
			contentType : "application/json",
			async: false,
			url : "join",
			data : JSON.stringify(jsonParams),
			timeout : 100000,
			success : function(data) {
				var json = JSON.parse(data);
				console.log("SUCCESS: ", data, " ---- " , json['freeSpaces'], " ---- " , json.freeSpaces);
				document.getElementById(id + "jr").innerHTML = "reject";
				document.getElementById(id + "jr").setAttribute('onclick','reject(' + id + ');return false;');
				if (document.getElementById(id + "fs")) {
				    document.getElementById(id + "fs").innerHTML = json.freeSpaces;
				}
				location.reload();
			},
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
		
    };
    
    // reject from the event
    function reject(id) {
    	dorado = JSON.stringify({"eventId":id});
    	
		$.ajax({
			type : "POST",
			contentType : "application/json",
			async: false,
			url : "reject",
			data : JSON.stringify({"eventId":id}),
			timeout : 100000,
			success : function(data) {
				var json = JSON.parse(data);
				console.log("SUCCESS: ", data, " ---- " , json['freeSpaces'], " ---- " , json.freeSpaces);
				document.getElementById(id + "jr").innerHTML = "join";
				document.getElementById(id + "jr").setAttribute('onclick','join(' + id + ');return false;')
				if (document.getElementById(id + "fs")) {
				    document.getElementById(id + "fs").innerHTML = json.freeSpaces;
				}
				location.reload();
			},
			error : function(e) {
				console.log("ERROR: ", e);
			},
			done : function(e) {
				console.log("DONE");
			}
		});
		
    };
    

