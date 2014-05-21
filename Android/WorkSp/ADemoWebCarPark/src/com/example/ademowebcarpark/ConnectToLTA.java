package com.example.ademowebcarpark;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import android.os.AsyncTask;

public class ConnectToLTA extends AsyncTask<String, Integer, ArrayList<CarPark>> {

	@Override
	protected ArrayList<CarPark> doInBackground(String... params) {
		
		ArrayList<CarPark> listCarPark = new ArrayList<CarPark>();
		URL url;
		try {
			url = new URL(
					"http://datamall.mytransport.sg/ltaodataservice.svc/CarParkSet");

		URLConnection conn = url.openConnection();

		conn.setRequestProperty("accept", "*/*");
		conn.addRequestProperty("AccountKey", "pRjYA2UxyWo4sPtUDSbIgA==");
		conn.addRequestProperty("UniqueUserID",
				"9b458365-6903-40a4-a4db-fd0eacb85a63");

		conn.connect();

		/*
		 * Reads in the XML data from the LTAODataService
		 */
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory
				.newInstance();
		DocumentBuilder dBuilder;
		dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(conn.getInputStream());
		doc.getDocumentElement().normalize();
		
		ParseXML parser = new ParseXML();										        
		listCarPark = parser.extractCarPark(doc);	
		
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return listCarPark;
	}
	
}
