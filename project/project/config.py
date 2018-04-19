MY_API_KEY = "AIzaSyCEZkK8keZauzogbqXzgaihstG2Pmbvhe8"
API_END_POINT = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"



PORT = {
    'Goloman': 18430,
    'Hands': 18431,
    'Holiday': 18432,
    'Welsh': 18433,
    'Wilkes': 18434
}

# Connection is bidirectional, so
NEIGHBOURS_SERVER = {
    'Goloman': ['Hands','Holiday','Wilkes'],
    'Hands': ['Wilkes', 'Goloman'],
    'Holiday': ['Welsh','Wilkes', 'Goloman'],
    'Welsh': ['Holiday'],
    'Wilkes': ['Goloman', 'Hands', 'Holiday']
}

COMMAND_LIST = ["AT", "IAMAT", "WHATSAT"]
Project_name = "CsRam 131"