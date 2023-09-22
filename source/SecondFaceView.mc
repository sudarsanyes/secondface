import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class SecondFaceView extends WatchUi.WatchFace {

    var bg;
    var t1, t2, f1;
    var faceRadius, viewWidth, viewHeight, viewXCenter, viewYCenter;
    var info;
    var hrIterator;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        bg = Toybox.WatchUi.loadResource(Rez.Drawables.bgImage);
        t1 = Toybox.WatchUi.loadResource(Rez.Fonts.t1);
        t2 = Toybox.WatchUi.loadResource(Rez.Fonts.t2);
        f1 = Toybox.WatchUi.loadResource(Rez.Fonts.f1);
        faceRadius = dc.getWidth() / 2;

        viewWidth = dc.getWidth();
        viewHeight = dc.getHeight();
        viewXCenter = viewWidth / 2;
        viewYCenter = viewHeight / 2;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Draw the background image
        dc.drawBitmap(0, 0, bg);

        // Get the time and other field parameters
        var clockTime = System.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour.format("%02d")]);
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        // Date
        var dateString = Lang.format("$1$", [Gregorian.info(Time.now(), Time.FORMAT_MEDIUM).day.toString()]);
        // Steps
        info = ActivityMonitor.getInfo();
        // Heart Rate
        hrIterator = ActivityMonitor.getHeartRateHistory(null, true);
        var hr = Activity.getActivityInfo().currentHeartRate;

        // Draw Seconds
        var angle = (getAngleFromTime(clockTime.sec) - 90);
        var x = getXFromAngle(angle, 99);
        var y = getYFromAngle(angle, 99);
        dc.setColor(0xe29095, 0xe29095);
        dc.drawLine(getXFromAngle(angle, 40), getYFromAngle(angle, 40), x, y);
        x = getXFromAngle(angle, 60);
        y = getYFromAngle(angle, 60);
        dc.setColor(0xe29095, 0xe29095);
        dc.fillCircle(x, y, 9);

        // Draw the time, date, and other fields
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter, viewYCenter - 147, t1, hourString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(viewXCenter, viewYCenter - 70, t1, minuteString, Graphics.TEXT_JUSTIFY_CENTER);

        // Other fields
        dc.setColor(0xe3fff7, Graphics.COLOR_TRANSPARENT);
        // Date (15 min pos)
        dc.drawText(viewWidth - 40, viewYCenter - 15, f1, dateString, Graphics.TEXT_JUSTIFY_CENTER);
        // Steps (60 min pos)
        dc.drawText(viewXCenter, 10, f1, info.steps.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        // Heart Rate (30 min pos)
        if (null != hr) {
            dc.drawText(viewXCenter, viewHeight - 40, f1, hr.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
        // Floors Climbed (90 min pos)
        dc.drawText(40, viewYCenter - 15, f1, info.floorsClimbed.toString(), Graphics.TEXT_JUSTIFY_CENTER);
    }

    // gets the X from the angle in degrees. Offset is the number to be added to x. 
    function getXFromAngle(angle as Number, offset as Number) {
        var x = ((faceRadius - offset) * Math.cos(angle * (Math.PI / 180))) + 209;
        return x;
    }

    // gets the Y from the angle in degrees. Offset is the number to be added to x. 
    function getYFromAngle(angle as Number, offset as Number) {
        var y = ((faceRadius - offset) * Math.sin(angle * (Math.PI / 180))) + 209;
        return y;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    // Get the angle from time (val is the sec, min, or hour)
    function getAngleFromTime(val as Number) {
        return (((val * 360) / 60));
    }
}
