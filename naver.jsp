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
String searchaddr = "����Ư���� ���ı� �ø��ȷ�35�� 125";

searchaddr = URLEncoder.encode(searchaddr,"UTF-8");

//�ʼ��� query�� �ּҸ�..������ �ɼ��� api����.
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
	//���̹��� �ݵ�� GET������� ȣ���ؾ���.
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
	//������� �غ��� �˰����� json������ Ʈ�����·� ���ϵǼ� ��� �Ľ� �ؾ� ���ϴ� ��ǥ�� ���´�.
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
	System.out.println("x��ǥ==" + x + " y��ǥ==" + y);
	result = "x��ǥ==" + x + " y��ǥ==" + y;
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
                     '   <h3>�������̼�</h3>',
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