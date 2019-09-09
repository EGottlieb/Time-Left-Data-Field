// Version History
// 1.0.0 - intial release

using Toybox.WatchUi;


class TimeLeftDataFieldView extends WatchUi.SimpleDataField {

 	const DEFAULT_STARTING_TIME = 3600; // seconds
    var startingTime = readKeyInt(Application.getApp(),"startingTimeSetting",DEFAULT_STARTING_TIME) * 1000; // start time on countdown timer
	var timeUpMessage = Application.getApp().getProperty("endMessage");
	var pauseWithTimer = Application.getApp().getProperty("pauseSetting");
	
	var timeLeft = 0;	 // time left in milliseconds
	var hrs = 0;		 // hours left
	var mins = 0;		 // minutes left
	var secs = 0;		 // seconds left
	var timeLeftString = "00:00:00"; // string representing hrs:min:sec
	
    function initialize() {
        SimpleDataField.initialize();
        label = WatchUi.loadResource(Rez.Strings.timeLeftLabel);
		        
    }


    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
 		
		if (info.elapsedTime != null) {
			if (pauseWithTimer == true) { 					// pause countdown when timer is paused
				timeLeft = startingTime - info.timerTime;
			} else {  										// continue countdown even if timer is paused
				timeLeft = startingTime - info.elapsedTime;
			}
			
		} else {  // info.elapsedTime is null
			
			timeLeft = 0;
		}

		if (timeLeft > 0) {
		
			secs = (timeLeft / 1000) % 60;
			mins = (timeLeft / (1000*60)) % 60;
			hrs =  (timeLeft / (1000*60*60)) % 24; 

			timeLeftString = Lang.format("$1$:$2$:$3$", [hrs.format("%02d"), mins.format("%02d"), secs.format("%02d")]);

		} else {
			
			timeLeftString = timeUpMessage;
			
		}

        return timeLeftString;
    }

	function readKeyInt(myApp,key,thisDefault) {
    	var value = myApp.getProperty(key);
    	if(value == null || !(value instanceof Number)) {
        	if(value != null) {
            	value = value.toNumber();
        	} else {
            	value = thisDefault;
        	}
    	}
    	return value;
	}

	function readKeyFloat(myApp,key,thisDefault) {
    	var value = myApp.getProperty(key);
    	if(value == null || !(value instanceof Float)) {
        	if(value != null) {
            	value = value.toFloat();
        	} else {
            	value = thisDefault;
        	}
    	}
    	return value;
	}

}