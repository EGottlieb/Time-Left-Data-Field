// Version History
// 1.0.0 - intial release

using Toybox.WatchUi;
using Toybox.Lang;


class TimeLeftDataFieldView extends WatchUi.SimpleDataField {

 	const DEFAULT_STARTING_TIME = 3600; // seconds
    var startingTime as Lang.Number = Application.Properties.getValue("startingTimeSetting") * 1000; // start time on countdown timer
	var timeUpMessage as Lang.String = Application.Properties.getValue("endMessage");
	var pauseWithTimer = Application.Properties.getValue("pauseSetting");
	var compactTime = Application.Properties.getValue("compactDisplay");
	
	var timeLeft as Lang.Number = 0;	 // time left in milliseconds
	var hrs as Lang.Number = 0;		 // hours left
	var mins as Lang.Number = 0;		 // minutes left
	var secs as Lang.Number = 0;		 // seconds left
	var timeLeftString as Lang.String = "00:00:00"; // string representing hrs:min:sec
	
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

			if (compactTime == true) {
			
				if (hrs > 0) {
					timeLeftString = Lang.format("$1$:$2$", [hrs.format("%02d"), mins.format("%02d")]);
				} else {
					timeLeftString = Lang.format("$1$:$2$", [mins.format("%02d"), secs.format("%02d")]);
				}
				
			} else {
		
				timeLeftString = Lang.format("$1$:$2$:$3$", [hrs.format("%02d"), mins.format("%02d"), secs.format("%02d")]);
			}

		} else {
			
			timeLeftString = timeUpMessage;
			
		}

        return timeLeftString;
    }


}