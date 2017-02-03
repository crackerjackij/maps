<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.io.*"%>    
<%@ page import="java.net.*"%>    
<%@ page import="java.util.*"%>    
<%@ page import="java.security.*"%>    
<%@ page import="javax.net.ssl.HttpsURLConnection"%>    
<%@ page import="javax.net.ssl.SSLContext"%>    
<%@ page import="org.json.simple.JSONArray"%>    
<%@ page import="org.json.simple.JSONObject"%>    
<%@ page import="org.json.simple.parser.JSONParser"%>    
<%@ page import="org.json.simple.parser.ParseException"%>    

<%
String searchaddr = "서울특별시 송파구 올림픽로35길 125";

searchaddr = URLEncoder.encode(searchaddr,"UTF-8");

//필수는 query로 주소만..나머지 옵션은 api참고.
String api = "https://openapi.naver.com/v1/map/geocode?query="+searchaddr;
StringBuffer sb = new StringBuffer();
String result = "";
String x = "";
String y = "";

try {
	URL url = new URL(api);
	HttpsURLConnection http = (HttpsURLConnection)url.openConnection();
	http.setRequestProperty("X-Naver-Client-Id", "7S0CLquPNyBWZVoqAglG");
	http.setRequestProperty("X-Naver-Client-Secret", "tS6KoorXEC");
	//http.setDoOutput(true);
	//네이버는 반드시 GET방식으로 호출해야함.
	http.setRequestMethod("GET");
	http.connect();
	
	InputStreamReader in = new InputStreamReader(http.getInputStream(),"utf-8");
	BufferedReader br = new BufferedReader(in);

	String line;
	while ((line = br.readLine()) != null) {
		sb.append(line).append("\n");
	}

	JSONParser parser = new JSONParser();
	JSONObject jsonObject;
	JSONObject jsonObject2;
	JSONObject jsonObject3;
	JSONArray jsonArray;
	
	jsonObject = (JSONObject)parser.parse(sb.toString());
	//디버깅을 해보면 알겠지만 json구조가 트리형태로 리턴되서 몇번 파싱 해야 원하는 좌표가 나온다.
	jsonObject = (JSONObject)jsonObject.get("result");
	jsonArray = (JSONArray)jsonObject.get("items");
	for(int i=0;i<jsonArray.size();i++){
		jsonObject2 = (JSONObject) jsonArray.get(i);
		if(null != jsonObject2.get("point")){
			jsonObject3 = (JSONObject) jsonObject2.get("point");
			x = (String) jsonObject3.get("x").toString();
			y = (String) jsonObject3.get("y").toString();
		}
	}
	
	//System.out.println(sb.toString());
	System.out.println("x좌표==" + x + " y좌표==" + y);
	result = "x좌표==" + x + " y좌표==" + y;
	br.close();
	in.close();
	http.disconnect();
	
} catch (IOException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} 
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=7S0CLquPNyBWZVoqAglG"></script>
<title>Insert title here</title>
</head>
<body>
<%=result %>
<div id="map" style="width:100%;height:400px;"></div>
<script>
var x = '<%=x%>';
var y = '<%=y%>';
var cityhall = new naver.maps.LatLng(y, x);

var mapOptions = {
    center: cityhall,
    zoom: 10,
    scaleControl : true,
    logoControl : true,
    mapDataControl : true,
    zoomControl : true
};

var map = new naver.maps.Map('map', mapOptions);

var marker = new naver.maps.Marker({
    position: cityhall,
    map: map
});

var contentString = [
                     '<div class="iw_inner">',
                     '   <h3>인포메이션</h3>',
                     '</div>'
                 ].join('');
                 
var infowindow = new naver.maps.InfoWindow({
    content: contentString
});

naver.maps.Event.addListener(marker, "click", function(e) {
    if (infowindow.getMap()) {
        infowindow.close();
    } else {
        infowindow.open(map, marker);
    }
});

</script>
</body>
</html>