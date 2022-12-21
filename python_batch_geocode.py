#given an input_filename csv with column names and addresses, this script returns an updated output_filename using Google Maps API
import pandas as pd
import requests
import logging
import time
logger = logging.getLogger("root")
logger.setLevel(logging.DEBUG)
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
logger.addHandler(ch)
API_KEY = 'AIzaSyDhbsD0Jwm5wNIQ54Vdh9mG2nxaxh2Y3q8'
BACKOFF_TIME = 30
output_filename = '/content/output_geocoded.csv'
input_filename = "/content/sample2.csv"
address_column_name = "Address"
RETURN_FULL_RESULTS = False
data = pd.read_csv(input_filename, encoding='utf8')
addresses = data[address_column_name].tolist()
def get_google_results(address, api_key=None, return_full_response=False):
    geocode_url = "https://maps.googleapis.com/maps/api/geocode/json?address={}".format(address)
    if api_key is not None:
        geocode_url = geocode_url + "&key={}".format(api_key)
    results = requests.get(geocode_url)
    results = results.json()
    if len(results['results']) == 0:
        output = {
            "formatted_address" : None,
            "latitude": None,
            "longitude": None,
            "accuracy": None,
            "google_place_id": None,
            "type": None,
            "postcode": None
        }
    else:    
        answer = results['results'][0]
        output = {
            "formatted_address" : answer.get('formatted_address'),
            "latitude": answer.get('geometry').get('location').get('lat'),
            "longitude": answer.get('geometry').get('location').get('lng'),
            "accuracy": answer.get('geometry').get('location_type'),
            "google_place_id": answer.get("place_id"),
            "type": ",".join(answer.get('types')),
            "postcode": ",".join([x['long_name'] for x in answer.get('address_components') 
                                  if 'postal_code' in x.get('types')])
        }    
    output['input_string'] = address
    output['number_of_results'] = len(results['results'])
    output['status'] = results.get('status')
    if return_full_response is True:
        output['response'] = results 
    return output
test_result = get_google_results("London, England", API_KEY, RETURN_FULL_RESULTS)
if (test_result['status'] != 'OK') or (test_result['formatted_address'] != 'London, UK'):
    logger.warning("There was an error when testing the Google Geocoder.")
    raise ConnectionError('Problem with test results from Google Geocode - check your API key and internet connection.')
results = []
for address in addresses:
    geocoded = False
    while geocoded is not True:
        try:
            geocode_result = get_google_results(address, API_KEY, return_full_response=RETURN_FULL_RESULTS)
        except Exception as e:
            logger.exception(e)
            logger.error("Major error with {}".format(address))
            logger.error("Skipping!")
            geocoded = True
        if geocode_result['status'] == 'OVER_QUERY_LIMIT':
            logger.info("Hit Query Limit! Backing off for a bit.")
            time.sleep(BACKOFF_TIME * 60) # sleep for 30 minutes
            geocoded = False
        else:
            if geocode_result['status'] != 'OK':
                logger.warning("Error geocoding {}: {}".format(address, geocode_result['status']))
            logger.debug("Geocoded: {}: {}".format(address, geocode_result['status']))
            results.append(geocode_result)           
            geocoded = True
    if len(results) % 100 == 0:
    	logger.info("Completed {} of {} address".format(len(results), len(addresses)))  
    if len(results) % 500 == 0:
        pd.DataFrame(results).to_csv(output_filename)
logger.info("Finished geocoding all addresses")
pd.DataFrame(results).to_csv(output_filename, encoding='utf8')