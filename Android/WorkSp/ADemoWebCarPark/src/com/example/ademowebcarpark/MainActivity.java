package com.example.ademowebcarpark;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import android.app.ExpandableListActivity;
import android.os.Bundle;
import android.widget.ExpandableListAdapter;
import android.widget.SimpleExpandableListAdapter;

public class MainActivity extends ExpandableListActivity {

	private static final String GROUP = "GROUP";
	private static final String ITEM = "ITEM";

	private ExpandableListAdapter mAdapter;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		ArrayList<CarPark> listCarPark = new ArrayList<CarPark>();

		try {
			listCarPark = new ConnectToLTA().execute("a").get();

			List<Map<String, String>> groupData = new ArrayList<Map<String, String>>();
			List<List<Map<String, String>>> childData = new ArrayList<List<Map<String, String>>>();

			for (CarPark carPark : listCarPark) {

				Map<String, String> curGroupMap = new HashMap<String, String>();
				groupData.add(curGroupMap);
				curGroupMap.put(GROUP, carPark.getDevelopment());

				List<Map<String, String>> children = new ArrayList<Map<String, String>>();
				Map<String, String> curChildMap = new HashMap<String, String>();
				children.add(curChildMap);
				curChildMap.put(GROUP, Integer.toString(carPark.getLots()));
				curChildMap.put(ITEM, "Available Lots");
				childData.add(children);
			}

			// Set up our adapter
			mAdapter = new SimpleExpandableListAdapter(this, groupData,
					android.R.layout.simple_expandable_list_item_1,
					new String[] { GROUP, ITEM }, new int[] {
							android.R.id.text1, android.R.id.text2 },
					childData, android.R.layout.simple_expandable_list_item_2,
					new String[] { GROUP, ITEM }, new int[] {
							android.R.id.text1, android.R.id.text2 });
			setListAdapter(mAdapter);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
