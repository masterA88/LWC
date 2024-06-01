trigger ContentVersionTrigger on ContentVersion (after insert) {
	for(ContentVersion cv: trigger.new){
           ContentVersionTriggerHandler.callGoogleDrive(cv.Id); 
	}
}