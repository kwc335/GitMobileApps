package com.example.ademowebcarpark;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ParseXML {

	public ArrayList<CarPark> extractCarPark(Document xmlDocument){
		
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		ArrayList<CarPark> listCarPark = new ArrayList<CarPark>();

		try {

			NodeList nodelist = xmlDocument.getElementsByTagName("m:properties");

			for (int i = 0; i < nodelist.getLength(); i++) {
				Node node = nodelist.item(i);												
				NodeList childList = node.getChildNodes();				
				
				CarPark carPark = new CarPark();
				
				for (int j = 0; j < childList.getLength(); j++) {					
					Node childNode = childList.item(j);
					
					if(childNode.getNodeName().compareToIgnoreCase("d:CarParkID") == 0)
					{					
						carPark.setCarParkID(new Integer(childNode.getTextContent()));						
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:Area") == 0)
					{					
						carPark.setArea(childNode.getTextContent());
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:Development") == 0)
					{					
						carPark.setDevelopment(childNode.getTextContent());
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:Lots") == 0)
					{					
						carPark.setLots(new Integer(childNode.getTextContent()));
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:Summary") == 0)
					{					
						carPark.setSummary(childNode.getTextContent());
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:CreateDate") == 0)
					{										
						carPark.setCreateDate(formatter.parse(childNode.getTextContent()));
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:Latitude") == 0)
					{					
						carPark.setLatitude(new Double(childNode.getTextContent()));
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:Longitude") == 0)
					{													
						carPark.setLongitude(new Double(childNode.getTextContent()));
					}
					if(childNode.getNodeName().compareToIgnoreCase("d:Distance") == 0)
					{										
						carPark.setDistance(new Double(childNode.getTextContent()));						
					}
										
				}
				listCarPark.add(carPark);
				
			}

		} catch (DOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return listCarPark;
	}

}
