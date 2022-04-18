(
~custHash = OSCFunc({ arg msg, time, addr, recvPort;
		[msg, time, addr, recvPort].postln; },
'/BNOOSC/CustomHashtag/');
)