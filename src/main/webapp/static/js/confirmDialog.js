/**
 * 
 */
function CustomConfirm(){
	this.render = function(confirmTitle, 
			dialog,
			yes,
			no,
			op,
			id){
		var winW = window.innerWidth;
	    var winH = window.innerHeight;
		var dialogoverlay = document.getElementById('dialogoverlay');
	    var dialogbox = document.getElementById('dialogbox');
		dialogoverlay.style.display = "block";
	    dialogoverlay.style.height = winH+"px";
		
		document.getElementById('dialogboxhead').innerHTML = confirmTitle;
	    document.getElementById('dialogboxbody').innerHTML = dialog;
		document.getElementById('dialogboxfoot').innerHTML = '<button onclick="Confirm.yes(\''+op+'\',\''+id+'\')">' + yes + '</button> <button onclick="Confirm.no()">' + no + '</button>';

		var dwidth = document.getElementById('dialogbox').offsetWidth
		dialogbox.style.left = (winW/2) - (dwidth * .5)+"px";
		dialogbox.style.top = "100px";
		dialogbox.style.display = "block";
	}
	this.no = function(){
		document.getElementById('dialogbox').style.display = "none";
		document.getElementById('dialogoverlay').style.display = "none";
	}
	this.yes = function(op,id){
		if(op == "delete_event") {
           var jsonParams = {};
	       jsonParams['id'] = id;
		   $.ajax({
				type : "POST",
				contentType : "application/json",
				async: false,
				url : "delete-event",
				data : JSON.stringify(jsonParams),
				timeout : 100000,
				success : function(data) {
					console.log("SUCCESS");
					location.reload();
				},
				error : function(e) {
					console.log("ERROR: ", e);
				},
				done : function(e) {
					console.log("DONE");
			}});
		}
		document.getElementById('dialogbox').style.display = "none";
		document.getElementById('dialogoverlay').style.display = "none";
	}
}
