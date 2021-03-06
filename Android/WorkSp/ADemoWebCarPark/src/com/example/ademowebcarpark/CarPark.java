package com.example.ademowebcarpark;

import java.util.Date;

public class CarPark {

	private int carParkID;
	private String area;
	private String development;
	private int lots;
	private String summary;
	private Date createDate;
	private Double latitude;
	private Double longitude;
	private Double distance;
	
	public int getCarParkID() {
		return carParkID;
	}
	public void setCarParkID(int carParkID) {
		this.carParkID = carParkID;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getDevelopment() {
		return development;
	}
	public void setDevelopment(String development) {
		this.development = development;
	}
	public int getLots() {
		return lots;
	}
	public void setLots(int lots) {
		this.lots = lots;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
	public Double getDistance() {
		return distance;
	}
	public void setDistance(Double distance) {
		this.distance = distance;
	}

}
