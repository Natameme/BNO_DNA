//TODO: Telegram Function
(
o = OSCFunc({ arg msg, time, addr, recvPort;
		[msg, time, addr, recvPort].postln;
	//Structure of this message: 4 floats with sentiment analysis and one string with message itself
},
'/BNOOSC/TelegramMsg//');
)