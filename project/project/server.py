import asyncio
import logging
import time
import json
import sys
import config
import datetime

Host = '127.0.0.1'
client_info_dict = dict()
location_radius_dict = dict() # {'kiwi.cs.ucla.edu': ['+34.068930,-118.445127', '5']}
time_diff_time = dict()

class Edisplay_to_consoleoServerClientProtocol(asyncio.Protocol):
    def __init__(self, loop):
        self.loop = loop

    def lon_info_args(self, info, args):
        logger.info(info + ' {}'.format(args))

    def connection_made(self, transport):
        peername = transport.get_extra_info('peername')
        self.transport = transport
        self.lon_info_args('Server Connected to the client at: (Address, Port) ==>', peername)

    def display_at_message(self, infotup):
        output_result = "AT"
        if len(infotup) == 5:
            for i in range(5):
                output_result = output_result + " " + infotup[i]
        return output_result

    def validateGPSInput(self, data_received): # Valid GPS and Return Locations(Float)
        data = data_received.split()
        lat_long_list = []
        locations = data[2]
        i = 1
        for value in locations[i:]:
            i += 1
            if value is '+' or value is '-':
                break

        latitude_str = locations[:i - 1]
        longitude_str = locations[i - 1:]

        try:
            latitude = float(latitude_str)
            longitue = float(longitude_str)
            if latitude < -90 or latitude > 90:
                self.lon_info_args("[server] Location Coordinate: Latitude {} is outside of bound", latitude_str)
                self.wrong_command(data_received)
                return False
            if longitue < -180 or longitue > 180:
                self.lon_info_args("[server] Location Coordinate: Longitude {} is outside of bound", longitude_str)
                self.wrong_command(data_received)
                return False

        except ValueError:
            logger.info("IAMAT_GPS: {0} and {1} is not a valid coordinate".format(latitude_str, longitude_str))
            self.wrong_command(data_received)
            return False
        lat_long_list.append(latitude_str)
        lat_long_list.append(longitude_str)
        lat_long_list.append(str((i - 1)))

        return lat_long_list

    def validIAMATInput(self, data_received): # Valid IAMAT & Return Locations(Float)
        # validate length
        data = data_received.split()
        data_length = len(data)
        if data_length < 4 or data_length > 4:
            self.lon_info_args("[server] wrong IAMAT command:", data_received)
            self.wrong_command(data_received)
            return False
        # display_to_consoleeck for valid GPA location
        location_list = self.validateGPSInput(data_received)
        return location_list

    def getTimeDifference(self, data_received):
        data = data_received.split()

        try:
            float(data[-1])
        except ValueError:
            self.wrong_command(data_received)
            return False

        if data[-1]:
            val = data[-1]

            if isinstance(float(val), float) == True:
                given_time = float(data[-1])

                sytem_time = time.time()
                time_diff = sytem_time - given_time
                try:
                    if time_diff > 0:
                        return '+' + str(time_diff)
                    else:
                        return str(time_diff)
                except ValueError:
                    return False
            else:
                self.lon_info_args("[server] time format:", data_received)
                self.wrong_command(data_received)
                return
        else:
            self.lon_info_args("[server] wrong Time format:", data_received)
            self.wrong_command(data_received)
            return

    def iamat(self, command_list, system_time):
        data_received = ' '.join(command_list)
        host_name, port = self.transport.get_extra_info('peername')
        locations = self.validIAMATInput(data_received)

        pos = 0
        lat = "-92"
        lon = "-182"

        client_ID = command_list[1]
        location = []
        if locations:
            lat = locations[0]
            lon = locations[1]
            pos = int(locations[2])
            locat = lat + "," + lon

            location.append(locat)

        if client_ID in location_radius_dict:
            location_radius_dict[client_ID] = location
        else:
            location_radius_dict[client_ID] = location

        logger.info('Valid AT message')
        tdiff = self.getTimeDifference(data_received)

        if len(command_list) < 4 or len(command_list) > 4:
            return False
        else:
            store_time = []
            store_time.append(tdiff)
            store_time.append(command_list[-1])

            time_diff_time[client_ID] = store_time

            try:
                float(command_list[3])
                str(command_list[1])
            except ValueError:
                self.wrong_command(data_received)
                return False


            msg = self.display_at_message((server_Name, tdiff, command_list[1], lat + lon, command_list[3]))
            logger.info('Updating self and network')
            self.parse_command(msg.split())
            msg = msg + '\r\n'
            self.lon_info_args("Server Answering the Client at port:", port)
            self.transport.write(msg.encode())
            self.transport.close()
        return True


    async def google_HTTP_request(self, places, cliname, lat, lon, Rad):
        host_name, port = self.transport.get_extra_info('peername')
        URL = ('/maps/api/place/nearbysearch/json?location={},{}&radius={}&key={}').format(lat, lon, Rad, config.MY_API_KEY)

        logger.info('Google API Connection made for client at port: {}'.format(port))
        reader, writer = await asyncio.open_connection(host="maps.googleapis.com", port=443, loop=self.loop, ssl=True)
        port_name = port
        location = []
        client_name = cliname
        client_ID = cliname
        host = host_name

        logger.info('Succefull Google API conneciton: {}'.format(port))
        google_host = "maps.googleapis.com"
        request_http = ('GET {0} HTTP/1.1\n''Host: {1}\n''Content-Type: text/plain; charset=utf-8\n''Connection: close\n\n').format(URL, google_host)
        logger.info('Sending HTTP request to Google:')
        writer.write(request_http.encode())
        await writer.drain()

        location.append(port_name)
        location.append(client_name)
        location.append(host)

        logger.info('Reading HTTP request from Google:')
        temp_value = await reader.read()

        logger.info('Parsing HTTP respose:')
        temp_value = (temp_value.decode()).split('\r\n\r\n')

        if client_ID in location_radius_dict:
            location_radius_dict[client_ID] = location
        else:
            location_radius_dict[client_ID] = location

        temp_value = json.loads(temp_value[1])
        temp_value["results"] = temp_value["results"][:places]

        get_client = location_radius_dict[client_ID]
        if len(get_client) < 1:
            logger.info("To get location must provide, Location and Radius")
            self.wrong_command("[server] To get location must provide, Location and Radius")
            return False

        atmsg = self.display_at_message(client_info_dict[cliname]) + '\r\n'
        self.transport.write(atmsg.encode())
        self.transport.write((json.dumps(temp_value)).encode())

        if len(get_client) < 1:
            logger.info("To get location must provide, Location and Radius")
            self.wrong_command("[server] To get location must provide, Location and Radius")
            return True
        self.lon_info_args('Writing Google result to the Client port at:', port)
        self.lon_info_args('Closing connection for client port at:', port)
        self.transport.close()

    def validateRadiusInput(self, data_received):
        data = data_received.split()

        try:
            int(data[-1])
        except ValueError:
            self.wrong_command(data_received)
            return False

        try:
            if int(data[-1]) > 20:
                logger.info("[server] WHATAT limit {} exceeded:".format(data[-1]))
                self.wrong_command(data_received)
                return False
            if int(data[-2]) > 50:
                logger.info("[server] WHATAT radius {} exceeded:".format(data[-2]))
                self.wrong_command(data_received)
                return False
        except ValueError:
            self.wrong_command(data_received)
            return False
        return True

    def validWHATSATInput(self, data_received):
        # valid radius and info limit
        radius_check = self.validateRadiusInput(data_received)

        if radius_check == False:
            self.wrong_command(data_received)
            return False

        # valid lengths
        rad_n_infos_list = []
        data = data_received.split()
        data_length = len(data)
        if data_length < 4 or data_length > 4:
            self.lon_info_args("[server] wrong WHATSAT command:", data_received)
            self.wrong_command(data_received)
            return False
        try:
            rad_n_infos_list.append(int(data[-2]))
            rad_n_infos_list.append(int(data[-1]))
        except ValueError:
            self.wrong_command(data_received)
            return False

        return rad_n_infos_list

    def whatsat(self, command_list):
        if command_list[1] not in client_info_dict:
            return False

        data_received = ' '.join(command_list)
        client_ID = command_list[1]
        radius = command_list[-1]

        if client_ID in location_radius_dict:
            if len(location_radius_dict[client_ID]) < 2:
                location_radius_dict[client_ID].append(radius)
            else:
                location_radius_dict[client_ID] = radius
        else:
            location_radius_dict[client_ID].append(radius)

        rad_infos_list = self.validWHATSATInput(data_received)
        Rad = rad_infos_list[-2]
        Places = rad_infos_list[-1]

        logger.info('WHATSAT is valid')
        CliName = command_list[1]
        Dat = client_info_dict[CliName]

        list = []
        list.append("AddExtra")
        list.append(Dat[2])
        list.append(Dat[3])
        list.append(Dat[4])

        converted_string = ' '.join(list)
        locations = self.validateGPSInput(converted_string)

        lat = "-92"
        lon = "-182"
        location = []
        if locations:
            lat = locations[0]
            lon = locations[1]
            locat = lat + "," + lon

            location.append(locat)
            location.append(Rad)
            location.append(Places)

        if client_ID in location_radius_dict:
            location_radius_dict[client_ID] = location
        else:
            location_radius_dict[client_ID] = location

        logger.info('Creating Task to request to google with Details {} {},{}'.format(Rad, lat, lon))
        asyncio.ensure_future(self.google_HTTP_request(Places, CliName, lat, lon, Rad), loop=self.loop)
        return True


    async def flooded_algorithm(self, msg, port, client_ID, host_name):
        for Serv in config.NEIGHBOURS_SERVER[server_Name]:
            location = []
            client_name = client_ID
            host = host_name
            port_name = port
            ServPort = config.PORT[Serv]
            if ServPort != port:
                try:
                    logger.info('Information propagating to the server:==> [{!r}] at port:{}'.format(Serv, ServPort))
                    read, write = await asyncio.open_connection(host=Host, port=ServPort, loop=self.loop)
                    write.write(msg.encode())
                    await write.drain()

                    location.append(port_name)
                    location.append(client_name)
                    location.append(host)
                    if client_ID in location_radius_dict:
                        location_radius_dict[client_ID] = location
                    else:
                        location_radius_dict[client_ID] = location

                    write.close()
                    logger.info('Successful!, the information propated to server {!r}'.format(Serv))

                    get_client = location_radius_dict[client_ID]
                    if len(get_client) < 1:
                        logger.info("To get location must provide, Location and Radius")
                        return False
                except:
                    logger.info("Heads UP!!, Server:==> [{!r}] is Unavailable!".format(Serv))

        self.transport.close()

    def parse_command(self, command_list):
        host_name, port = self.transport.get_extra_info('peername')
        clientID = command_list[3]

        if clientID in client_info_dict:
            logger.info('AT message is not flooded_algorithmed')
            self.transport.close()
            logger.info('Connection is closed')
        else:
            for i in range(1, 6):
                if clientID in client_info_dict:
                    client_info_dict[clientID].append(command_list[i])
                else:
                    client_info_dict[clientID] = [command_list[i]]

            msg = self.display_at_message(client_info_dict[clientID])

            asyncio.ensure_future(self.flooded_algorithm(msg, port, clientID, host_name), loop=self.loop)
        return True

    def display_to_consoleeck_command(self, command, command_list, system_time):
        data = ' '.join(command_list)

        error_detect = False
        if command == "IAMAT":
            logger.info('Given command is [IAMAT] Message string')
            if self.validIAMATInput(data) == False:
                error_detect = False
                return error_detect
            else:
                error_detect = self.iamat(command_list, system_time)

        elif command == "WHATSAT":
            logger.info('Given command is [WHATSAT] Message string')
            if self.validWHATSATInput(data) == False:
                error_detect = False
                return error_detect
            else:
                error_detect = self.whatsat(command_list)

        elif command == "AT":
            logger.info('Given command is [AT] Message string')
            error_detect = self.parse_command(command_list)

        elif command == " ":
            error_detect = True
        return error_detect

    def wrong_command(self, data):
        host_name, port = self.transport.get_extra_info('peername')
        message = '? {}'.format(data)
        self.lon_info_args('Not permitted!!, Invalid command', message)
        self.transport.write(message.encode())
        self.lon_info_args('Closing connection for Client port at:', port)
        self.transport.close()

    def data_received(self, data):
        host_name, port = self.transport.get_extra_info('peername')
        message = data.decode()
        command_list = message.split()
        self.lon_info_args('Message is Received!', message)
        system_time = time.time()

        command = command_list[0]

        error_detect = self.display_to_consoleeck_command(command, command_list, system_time)
        self.lon_info_args('Parsing finished!!, for the Client port at:', port)

        if error_detect != True:
            message = '? {}'.format(message)
            self.lon_info_args('Not permitted!!, Invalid command', message)
            self.transport.write(message.encode())
            self.lon_info_args('Closing connection for Client port at:', port)
            self.transport.close()


def main():
    # https://docs.python.org/3/library/asyncio-protocol.html#tcp-edisplay_to_consoleo-server-protocol
    if (len(sys.argv)) is not 2:
        print("Usage: [Server Name]")
        exit(1)

    server_Name = sys.argv[1]

    if server_Name in config.PORT:
        port_num = config.PORT[server_Name]
        loop = asyncio.get_event_loop()

        coro = loop.create_server(lambda: Edisplay_to_consoleoServerClientProtocol(loop), Host, port_num)
        server = loop.run_until_complete(coro)

        logger.info('Server {!r}, serving on {}'.format(server_Name, server.sockets[0].getsockname()))
        try:
            loop.run_forever()
        except KeyboardInterrupt:
            pass

        logger.info('Closing server {!r}'.format(server_Name))
        server.close()
        loop.run_until_complete(server.wait_closed())
        loop.close()
        logger.info('Server {!r} closed'.format(server_Name))

    else:
        print("Invalid server name: Use server [Goloman, Hands, Holiday, Welsh, Wilkes]")
        exit(1)


if __name__ == "__main__":
    if (len(sys.argv)) is not 2:
        print("Usage: [Server Name]")
        exit(1)
    server_Name = sys.argv[1]
    # reference: https://docs.python.org/2/howto/logging.html
    logger = logging.getLogger(server_Name)
    logger.setLevel(logging.DEBUG)

    file_handler = logging.FileHandler('{}.log'.format(server_Name))
    file_handler.setLevel(logging.DEBUG)

    display_to_console = logging.StreamHandler()
    display_to_console.setLevel(logging.DEBUG)

    formatter = logging.Formatter('- %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    display_to_console.setFormatter(formatter)

    logger.addHandler(file_handler)
    logger.addHandler(display_to_console)

    main()