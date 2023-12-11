import requests
from PIL import Image
from flask import Flask, jsonify, request
import os
import cv2
import folium
from selenium import webdriver
import time
import numpy as np
import firebase_admin as admin;
from firebase_admin import storage

import sys
import torch
from deepforest import main
import os
import cv2
import urllib.request
import numpy as np


cred = admin.credentials.Certificate("lib/resources/api/vanrakshak-1db86-firebase-adminsdk-thgz2-58a898d20b.json")
default_app = admin.initialize_app(
    cred,
    {'databaseURL': "https://vanrakshak-1db86-default-rtdb.asia-southeast1.firebasedatabase.app/",
     'storageBucket': "vanrakshak-1db86.appspot.com"}
)

app = Flask(__name__)

@app.route('/satelliteimage',methods=['GET'])
def satelliteImageScript():
    latlngzoom = str(request.args['LatLong']).split(",")
    imageID = str(request.args['ProjectID'])
    zoom = str(request.args['zoomlevel'])
    if zoom == 0: zoom=15
    output = {}
    polygon_coords =[]
    elevationList = []

    for i in range(0,len(latlngzoom),2):
        url = "https://maps.googleapis.com/maps/api/elevation/json?locations=" + str(latlngzoom[i]) + "," + str(latlngzoom[i+1]) + "&key=AIzaSyC5QkMgaiQo3G7RH95BWJoqzWbKczWVCkU"
        x = requests.get(url)
        elevationList.append(x.json()["results"][0]["elevation"])
        polygon_coords.append((float(latlngzoom[i]), float(latlngzoom[i+1])))

    center_lat = sum(lat for lat, _ in polygon_coords) / len(polygon_coords)
    center_lng = sum(lng for _, lng in polygon_coords) / len(polygon_coords)

    # sw = df[['Lat', 'Long']].min().values.tolist()
    # ne = df[['Lat', 'Long']].max().values.tolist()  

    tile_layer = "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"

    my_map = folium.Map(location=[center_lat, center_lng], zoom_start=float(zoom), tiles=tile_layer, attr='Google Maps')
    
    folium.Polygon(locations=polygon_coords, color='blue').add_to(my_map)

    my_map.save(os.getcwd() + "\\assets\\satelliteMap.html")
    # my_map = folium.Map(location=[center_lat, center_lng],zoom_mag = zoom_start)

    my_map.fit_bounds(polygon_coords)
    
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')  
    driver = webdriver.Chrome(options=options)  

    driver.get(os.getcwd() + "\\assets\\satelliteMap.html") 
    time.sleep(2)

    ##########################################################################################################################################################################

    screenshot_path = os.getcwd() + "\\assets\\" + imageID + "_____ConstructionPolygonSatelliteImageUnmasked.png"
    driver.save_screenshot(screenshot_path)

    driver.quit()

    img = Image.open(screenshot_path)

    desired_size = (1000, 1000)
    img = img.resize(desired_size, Image.ANTIALIAS)

    img.save(screenshot_path)

    fileName = os.getcwd() + "\\assets\\" + imageID + "_____ConstructionPolygonSatelliteImageUnmasked.png"
    bucket = storage.bucket()
    blob = bucket.blob(f"SatelliteImages/PolygonUnmasked/{imageID}_____ConstructionPolygonSatelliteImageUnmasked.png")
    blob.upload_from_filename(fileName)

    blob.make_public()

    print("your file url", blob.public_url)

    print(f"Screenshot saved with size {desired_size}")
    output['result'] = "The map has successfully been created"
    output['satelliteImageUnmasked'] =  blob.public_url
    output['elevationList'] = elevationList

    ##########################################################################################################################################################################
    
    img = cv2.imread(os.getcwd() + "\\assets\\" + imageID + "_____ConstructionPolygonSatelliteImageUnmasked.png")
    hsv_image = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    
    lower_blue = np.array([90, 50, 50])
    upper_blue = np.array([130, 255, 255])

    blue_mask = cv2.inRange(hsv_image, lower_blue, upper_blue)

    mask = np.zeros_like(blue_mask)

    contours, _ = cv2.findContours(blue_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    cv2.drawContours(mask, contours, -1, 255, thickness=cv2.FILLED)

    result_image = cv2.bitwise_and(img, img, mask=mask)
   
    # gray = cv2.cvtColor(result_image, cv2.COLOR_BGR2GRAY)

    # _, mask = cv2.threshold(gray, 1, 255, cv2.THRESH_BINARY)

    # b, g, r = cv2.split(result_image)

    # black_mask = cv2.inRange(result_image, (0, 0, 0), (0, 0, 0))

    # mask = cv2.bitwise_and(mask, cv2.bitwise_not(black_mask))

    # rgba = [b, g, r, mask]
    # result_image = cv2.merge(rgba, 4)

    cv2.imwrite(os.getcwd() + "\\assets\\" + imageID + "_____ConstructionPolygonSatelliteImageMasked.png", result_image)

    fileName = os.getcwd() + "\\assets\\" + imageID + "_____ConstructionPolygonSatelliteImageMasked.png"
    bucket = storage.bucket()
    blob = bucket.blob(f"SatelliteImages/PolygonMasked/{imageID}_____ConstructionPolygonSatelliteImageMasked.png")
    blob.upload_from_filename(fileName)

    blob.make_public()

    print("your file url", blob.public_url)

    output['satelliteImageMasked'] =  blob.public_url

    ##########################################################################################################################################################################

    os.remove(os.getcwd() + "\\assets\\" + imageID + "_____ConstructionPolygonSatelliteImageMasked.png")
    os.remove(os.getcwd() + "\\assets\\" + imageID + "_____ConstructionPolygonSatelliteImageUnmasked.png")
    os.remove(os.getcwd() + "\\assets\\satelliteMap.html")
    return jsonify(output)

#########################################################################################################################################################################################

@app.route('/treeEnumeration',methods=['GET'])
def treeEnumerationScript():
    imageLink = str(request.args['imageLink'])
    imageID = str(request.args['ProjectID'])

    path_1 = "D:\\SIHMODELS\\TreeEnumeration"
    sys.path.append(path_1)
    # img_path1 = "D:\\SIHMODELS\\TreeEnumeration.JPEG"
    # img1 = cv2.imread(img_path1, 1)
    req = urllib.request.urlopen(imageLink)
    arr = np.asarray(bytearray(req.read()), dtype=np.uint8)
    img1 = cv2.imdecode(arr, -1)

    path_to_model = "D:/SIHMODELS/TreeEnumeration.pth"
    loaded_model = main.deepforest()
    loaded_model.model.load_state_dict(torch.load(path_to_model))
    loaded_model.eval()
    
    box_info2 = loaded_model.predict_image(img1, return_plot=False)
    num_trees2 = len(box_info2)
    print("Number of trees:", num_trees2)
    
    output = {}
    output['treeCount'] = num_trees2

    img1 = loaded_model.predict_image(img1, return_plot=True)
    
    path_for_images = os.getcwd() + "\\assets\\" + imageID + "_____TreeEnumeratedImage.png"

    cv2.imwrite(path_for_images, cv2.cvtColor(img1, cv2.COLOR_RGB2BGR))

    fileName = os.getcwd() + "\\assets\\" + imageID + "_____TreeEnumeratedImage.png"
    bucket = storage.bucket()
    blob = bucket.blob(f"EnumerationImages/{imageID}_____TreeEnumeratedImage.png")
    blob.upload_from_filename(fileName)

    blob.make_public()

    print("your file url", blob.public_url)

    output['enumeratedImageLink'] =  blob.public_url

    return jsonify(output)



if __name__ == '__main__':
    app.run()