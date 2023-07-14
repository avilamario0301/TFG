# from helium import *
import pandas
from bs4 import BeautifulSoup
import requests
import time
import os

def getHousingData(url, data : dict):
    listing_types = ["Alquiler Amueblado", "Alquiler", "Venta"] 
    html = requests.get(url)
    soup = BeautifulSoup(html.text, "html.parser")
    children = soup.findChildren("div", {"id" : "bigsearch-results-inner-results"})    
    ul = children[0].find_all("ul")
    for li in ul[0].find_all("li"):
      confirms = {"Tipo" : 0, "Ubicacion": 0, "Alquiler" : 0, "Alquiler Amueblado": 0, "Venta" : 0, "Habitaciones": 0, "Baños": 0, "Parqueos": 0, "Construccion": 0, "Condicion": 0}
      data["Tipo"].append(li.find("div", {"class": "type"}).text)
      confirms["Tipo"] = 1
      data["Ubicacion"].append(li.find("div", {"class": "title1"}).text)
      confirms["Ubicacion"] = 1
      for title2 in li.find_all("div", {"class": "title2"}):
        for string in listing_types:
          if(string in title2.text):
            data[string].append(title2.text.replace('"',"").split(":")[1].replace("/Mes","").lstrip())
            confirms[string] = 1
            break

      for label in li.find_all("label"):
        match label.find("b").text:
          case "Habitaciones":
            data["Habitaciones"].append(label.text.split(":")[-1].strip())
            confirms["Habitaciones"] = 1
          case "Baños":
            data["Baños"].append(label.text.split(":")[-1].strip())
            confirms["Baños"] = 1
          case "Parqueos":
            data["Parqueos"].append(label.text.split(":")[-1].strip())
            confirms["Parqueos"] = 1
          case "Construcción":
            data["Construccion"].append(label.text.split(":")[-1].strip())
            confirms["Construccion"] = 1
          case "Condición":
            data["Condicion"].append(label.text.split(":")[-1].strip())
            confirms["Condicion"] = 1   
      for key, value in confirms.items():
        if(value == 0):
          data[key].append(" ")       
    
    
    return data


if __name__ == "__main__":
  data = {"Tipo" : [], "Ubicacion": [], "Alquiler" : [], "Alquiler Amueblado": [], "Venta" : [], "Habitaciones": [], "Baños": [], "Parqueos": [], "Construccion": [], "Condicion": []}
  for i in range(0,42): #son 41 paginas 0,42
    data = getHousingData(f"https://www.supercasas.com/buscar/?Locations=47&PriceType=401&PagingPageSkip={i}", data)
    df = pandas.DataFrame(data = data)
    df.to_csv("data.csv")





