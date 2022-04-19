(
o = OSCFunc({ arg msg, time, addr, recvPort;
		[msg, time, addr, recvPort].postln; },
'/BNOOSC/Sentiment/');

)

(
o = OSCFunc({ arg msg, time, addr, recvPort;
		[msg, time, addr, recvPort].postln; },
'/BNOOSC/CustomHashtag/');
)

(
o = OSCFunc({ arg msg, time, addr, recvPort;
		[msg, time, addr, recvPort].postln; },
'/BNOOSC/HashNote/');
)

(
o = OSCFunc({ arg msg, time, addr, recvPort;
		[msg, time, addr, recvPort].postln; },
'/BNOOSC/TelegramMsg/');
)



