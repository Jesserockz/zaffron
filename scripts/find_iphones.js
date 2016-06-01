var icloud = require("find-my-iphone").findmyphone;
 
icloud.apple_id = process.env.ICLOUD_EMAIL;
icloud.password = process.env.ICLOUD_PASSWORD; 

var devices = [];

var getDevices = function(msg) {
  icloud.getDevices(function(error, devs) {
    devices = [];

    if (error) {
      throw error;
    }
    var reply = "Which device would you like to find?\n";
    var count = 1;

    //pick a device with location and findMyPhone enabled 
    devs.forEach(function(d) {
      if (d.location && d.lostModeCapable && (d.modelDisplayName=='iPad' || d.modelDisplayName=='iPhone')) {
        devices.push(d);
        reply += "["+(count++)+"] " + d.name + "\n";
      }
    });
    
    msg.reply(reply);

    // if (device) {

    //   //gets the distance of the device from my location 
    //   var myLatitude = 38.8977;
    //   var myLongitude = -77.0366;

    //   icloud.getDistanceOfDevice(device, myLatitude, myLongitude, function(err, result) {
    //     console.log("Distance: " + result.distance.text);
    //     console.log("Driving time: " + result.duration.text);
    //   });

    //   // icloud.alertDevice(device.id, function(err) {
    //   //   console.log("Beep Beep!");
    //   // });

    //   icloud.getLocationOfDevice(device, function(err, location) {
    //     console.log(location);
    //   });
    // }
  });
};

var findDevice = function(msg) {
  var device = devices[parseInt(msg.match[1]) - 1];

  if(device != undefined) {
    console.log("Alerting " + device.id, device.name);
    icloud.alertDevice(device.id, function(err) {
      if(err == undefined) {
        msg.reply("Beep beep");
      } else {
        msg.reply("Error finding " + device.name);
      }
    });
  } else {
    msg.reply("I couldn't find that device. Try `idevice list` to get a list of devices.");
  }
}

module.exports = function(robot) {
  robot.respond(/idevice list/i, function(msg) {
    getDevices(msg);
  });

  robot.respond(/idevice find (\d+)/i, function(msg) {
    findDevice(msg);
  });

}

