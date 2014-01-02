$(function(){
	
	$("#allbtn").click(function(){
		window.location.href = "/tasks/";
	})
	$("#pendingbtn").click(function(){
		window.location.href = "/tasks/?status=open";
	})
	$("#processingbtn").click(function(){
		window.location.href = "/tasks/?status=processing";
	})
	$("#completedbtn").click(function(){
		window.location.href = "/tasks/?status=completed";
	})
	$("#testingbtn").click(function(){
		window.location.href = "/tasks/?status=testing";
	})
	$("#testfailbtn").click(function(){
		window.location.href = "/tasks/?status=test-fail";
	})
	
});