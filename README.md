# remote-control-iot-app
Title: LightsRemote
iOS app for controlling lights over cheap remotes.

LightsRemote sends messages to broker to switch the lights on/off over the MQTT protocol. When broker
publishes a message to LightsRemote, its interface is updated accordingly.

To start using the app, connect it to the running broker. Then in the central "Lights" tab
you can manipulate lights by selecting the room that you want.

If you don't want to send/receive messages to/from the broker, switch to the "Connect" tab and disconnect.
Status will be set to "Disabled".
