import asyncio
# https://docs.python.org/3/library/asyncio-protocol.html#tcp-echo-client-protocol
class ClientProtocol(asyncio.Protocol):
    def __init__(self, message, loop):
        self.message = message
        self.loop = loop

    def connection_made(self, transport):
        transport.write(self.message.encode())
        print('Data sent: {!r}'.format(self.message))

    def data_received(self, data):
        print('Data received: {!r}'.format(data.decode()))

    def connection_lost(self, exc):
        print('The server closed the connection')
        print('Stop the event loop')
        self.loop.stop()

loop = asyncio.get_event_loop()

message = input("Write your command: ")
coro = loop.create_connection(lambda: ClientProtocol(message, loop),
                              '127.0.0.1', 18430)
loop.run_until_complete(coro)
loop.run_forever()
loop.close()
