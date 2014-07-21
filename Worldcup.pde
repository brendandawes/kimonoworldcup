/*
World Cup Data display using Kimono Labs http://www.kimonolabs.com/worldcup/docs

You will need an api key from Kimono.

Create a text file named conf.properties in the data folder with these contents:

##

kimono.apikey = YOUR_API_KEY

##

config files taken from http://wiki.processing.org/index.php/External_configuration_files
@author toxi
*/

import java.text.SimpleDateFormat;
import java.util.Properties;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.util.datatypes.*;

SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

JSONArray playersJsonArray;
JSONArray teamsJsonArray;

ColorList palette = new ColorList();

P5Properties props;

String APIKEY;


void setup() {

   try {

    props=new P5Properties();
    props.load(openStream("conf.properties"));
    APIKEY = props.getProperty("kimono.apikey","");
    
  }
  catch(IOException e) {
    println("couldn't read config file...");

  }

	size(1200,800);

	smooth();

	rectMode(LEFT);

  palette = getColorTheme(100,"soft","teal,lilac");

	parseJSONFile("http://worldcup.kimonolabs.com/api/players?apikey="+APIKEY+"&limit=1000&fields=firstName,lastName,goals,teamId&sort=teamId");

	getTeams();
}

void draw() {

	background(100);
	translate(width/2,height/2);

	float a = 0;
    int distance;
    float amount;
    float inc;
    float rad;
    float x;
    float y;

	if (playersJsonArray != null) {

		a = 0;
    	distance = 300;
    	amount = playersJsonArray.size();
    	inc = (TWO_PI)/amount;
    	

			for (int i = 0; i < playersJsonArray.size(); i++) {

				a += inc;
     			x = sin(a)*distance;
     			y = cos(a)*distance;
     			rad = atan2((0-y), (0-x));
			
				JSONObject jsonObject = playersJsonArray.getJSONObject(i);
				
				pushMatrix();
    				rotate(rad);
            color c = palette.get(i%palette.size()).toARGB();
    				if (jsonObject.getInt("goals")>0) {
              
    					fill(255,255,0);
    				}else {
    					fill(75);
    				}
    				
    				textSize(11);
    				text(jsonObject.getString("firstName")+" "+jsonObject.getString("lastName"),distance,0);
    			popMatrix();	
    		
				
			}
	}

	if (teamsJsonArray != null) {

		a = 0;
    	distance = 150;
    	amount = teamsJsonArray.size();
    	inc = (TWO_PI)/amount;
    	

			for (int i = 0; i < teamsJsonArray.size(); i++) {

				a += inc;
     			x = sin(a)*distance;
     			y = cos(a)*distance;
     			rad = atan2((0-y), (0-x));
			
				JSONObject jsonObject = teamsJsonArray.getJSONObject(i);
				
				pushMatrix();
    				rotate(rad);
    				fill(200);
    				textSize(11);
    				text(jsonObject.getString("name"),distance,0);
    			popMatrix();	
    		
				
			}
	}
	
}

void chooseFileForProcessing() {

	selectInput("Select a JSON file to process:", "fileSelected");

}

void fileSelected(File selection) {
  if (selection == null) {
    exit();
  } else {
    parseJSONFile(selection.getAbsolutePath());
  }
}

void parseJSONFile(String path) {

	playersJsonArray = loadJSONArray(path);

	println("playersJsonArray.size(): "+playersJsonArray.size());

	
  
}

void getTeams() {

	teamsJsonArray = loadJSONArray("http://worldcup.kimonolabs.com/api/teams?apikey="+APIKEY+"&limit=250");

}

void keyPressed() {

	saveFrame("worldcup-####.png");
}

ColorList getColorTheme(int numOfColors, String colorWeight, String colorName) {

  String[] weights = split(colorWeight, ',');
  String[] colors = split(colorName, ',');
   
  ColorTheme theme = new ColorTheme("theme");
  
  for (int i=0; i < colors.length; i++) {
    String weight = weights[i%weights.length];
    String cName = colors[i];
    theme.addRange(weight+" "+cName,0.5);
}
  ColorList l = theme.getColors(numOfColors);
  //l.sort();
  return l;
   
   
 }

/**
 * simple convenience wrapper object for the standard
 * Properties class to return pre-typed numerals
 */
class P5Properties extends Properties {
 
  boolean getBooleanProperty(String id, boolean defState) {
    return boolean(getProperty(id,""+defState));
  }
 
  int getIntProperty(String id, int defVal) {
    return int(getProperty(id,""+defVal)); 
  }
 
  float getFloatProperty(String id, float defVal) {
    return float(getProperty(id,""+defVal)); 
  }  
}



