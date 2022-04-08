from pythonosc.udp_client import SimpleUDPClient

ip = "127.0.0.1"
port = 57121
client = SimpleUDPClient(ip, port)

while(True):
    message = input()
    self.client.send_message("/BNOInternal/Message", message)
