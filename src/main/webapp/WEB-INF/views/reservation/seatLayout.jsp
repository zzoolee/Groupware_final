<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
    integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
    crossorigin=""/>
<!-- Make sure you put this AFTER Leaflet's CSS -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
    integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
    crossorigin=""></script>

<h2>자율좌석예약</h2>
<br>

<c:if test="${not empty message }">
	<script type="text/javascript">
		alert("${message}");
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</script>
</c:if>

<c:set var="now" value="<%=new java.util.Date()%>" />

<div class="container">
  <div class="row bg-100 mb-3">
    <div class="col-sm-8 p-2 border">
    	<div id="map" style="height: 700px;"></div>
    </div>
    <div class="col-sm-4 p-2 border">
    	<div class="card" style="height: 700px;">
<!-- 		  <img class="card-img-top" src="../../assets/img//generic/66.jpg" alt="..." /> -->
		  <div class="card-body">
		    <h3 class="card-title">좌석예약 유의사항</h3>
		    <p>
		    	<span class="text-danger" data-feather="check"></span>
		    	당일 예약만 가능합니다.
		    </p>
		    <p>
		    	<span class="text-danger" data-feather="check"></span>
		    	초록색으로 표시된 좌석이 예약 가능한 좌석입니다.
		    </p>
		    <p>
		    	<span class="text-danger" data-feather="check"></span>
		    	예약 가능 좌석으로 표시되어 있더라도,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;다른 직원이 먼저 예약한 경우 예약이 불가합니다.
		    </p>
		    <hr/>
		    <form action="/rsv/confirmseat.do" method="post">
			    <div class="mb-4">
				    <h4 class="text-1000 mb-0">날짜</h4>
				    <p><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></p>
				    <h4 class="text-1000 mb-0">좌석 유형</h4>
				    <p id="offSePlace">원하는 좌석을 클릭해주세요.</p>
				    <h4 class="text-1000 mb-0">위치</h4>
				    <p id="offCdPlace">원하는 좌석을 클릭해주세요.</p>
				    <h4 class="text-1000 mb-0">좌석</h4>
				    <p id="srNoPlace">원하는 좌석을 클릭해주세요.</p>
				    <div id="hiddenPlace"></div>
			    </div>
				<hr/>
				<p>
					<span class="text-danger" data-feather="alert-circle"></span>
					위 내용 확인 후 예약 진행해주세요.
				</p>
			    <button class="btn btn-info me-1 mb-1 float-end">예약</button>
		    </form>
		  </div>
		</div>
    </div>
  </div>
</div>

<script>
var map = L.map('map', {crs: L.CRS.Simple, minZoom: -0.7, maxZoom: 2});

var bounds = [[0,0], [1080,1264]]; // 이미지의 해상도를 bounds로 설정한다.
L.imageOverlay('/resources/assets/gw/rsv/freeseatlayout.png', bounds).addTo(map); // 배경 이미지를 설정한다.

// L.circle([670.26, 171.27], {color: 'red',radius: 15, id:3333}).addTo(map)
// .bindPopup("iwatsuki <br />IT Support Department")
// .bindTooltip("iwatsuki", {permanent: false, direction: 'center'}).openTooltip().on("click", circleClick);

// L.circle([170, 290], {color: 'green',radius: 35, id:9999}).addTo(map)
// .bindTooltip("Name A", {permanent: true, direction: 'center'}).openTooltip().on("click", circleClick);

// L.circle([170, 410], {color: 'green',radius: 35}).addTo(map)
// .bindTooltip("Name B", {permanent: true, direction: 'center'}).openTooltip();

// L.circle([60, 170], {color: 'green',radius: 35}).addTo(map)
// .bindTooltip("Name C", {permanent: true, direction: 'center'}).openTooltip();

// L.circle([60, 290], {color: 'green',radius: 35}).addTo(map)
// .bindTooltip("Name D", {permanent: true, direction: 'center'}).openTooltip();

// L.circle([60, 410], {color: 'gray',radius: 35}).addTo(map)
// .bindPopup(    'Deneb')
// .bindTooltip("Name E", {permanent: true, direction: 'center'})
// .openTooltip();

var circles = [
	// 몰입형
	{
		"latlng" : [670.26, 171.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A01'}
	},
	{
		"latlng" : [670.26, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A02'}
	},
	{
		"latlng" : [670.26, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A03'}
	},
	{
		"latlng" : [670.26, 294.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A04'}
	},
	{
		"latlng" : [627, 171.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A05'}
	},
	{
		"latlng" : [627, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A06'}
	},
	{
		"latlng" : [627, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A07'}
	},
	{
		"latlng" : [627, 294.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A08'}
	},
	{
		"latlng" : [572, 171.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A09'}
	},
	{
		"latlng" : [572, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A10'}
	},
	{
		"latlng" : [572, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A11'}
	},
	{
		"latlng" : [572, 294.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A12'}
	},
	{
		"latlng" : [521, 200],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A13'}
	},
	{
		"latlng" : [521, 241],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A14'}
	},
	{
		"latlng" : [521, 282],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A15'}
	},
	{
		"latlng" : [464, 172],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A16'}
	},
	{
		"latlng" : [464, 213],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A17'}
	},
	{
		"latlng" : [464, 254],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A18'}
	},
	{
		"latlng" : [426, 202],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A19'}
	},
	{
		"latlng" : [426, 243],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A20'}
	},
	{
		"latlng" : [426, 285],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A21'}
	},
	{
		"latlng" : [370, 202],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A22'}
	},
	{
		"latlng" : [370, 243],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A23'}
	},
	{
		"latlng" : [370, 285],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A24'}
	},
	{
		"latlng" : [326, 171.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A25'}
	},
	{
		"latlng" : [326, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A26'}
	},
	{
		"latlng" : [326, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A27'}
	},
	{
		"latlng" : [326, 294.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A28'}
	},
	{
		"latlng" : [271, 171.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A29'}
	},
	{
		"latlng" : [271, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A30'}
	},
	{
		"latlng" : [271, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A31'}
	},
	{
		"latlng" : [271, 294.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A32'}
	},
	{
		"latlng" : [236, 171.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A33'}
	},
	{
		"latlng" : [236, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A34'}
	},
	{
		"latlng" : [236, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A35'}
	},
	{
		"latlng" : [236, 294.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A36'}
	},
	{
		"latlng" : [181, 171.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A37'}
	},
	{
		"latlng" : [181, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A38'}
	},
	{
		"latlng" : [181, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A39'}
	},
	{
		"latlng" : [150, 212.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A40'}
	},
	{
		"latlng" : [150, 253.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A41'}
	},
	{
		"latlng" : [150, 294.4],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A42'}
	},
	{
		"latlng" : [380, 381],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A43'}
	},
	{
		"latlng" : [339, 381],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A44'}
	},
	{
		"latlng" : [298, 381],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A45'}
	},
	{
		"latlng" : [208, 381],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A46'}
	},
	{
		"latlng" : [167, 381],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A47'}
	},
	{
		"latlng" : [126, 381],
		"option" : {color:'green',radius:15,offCd:'3FIMMER',offLoc:'A303',srNo:'A48'}
	},
	// 오픈형
	{
		"latlng" : [378, 499],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B01'}
	},
	{
		"latlng" : [337, 499],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B02'}
	},
	{
		"latlng" : [296, 499],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B03'}
	},
	{
		"latlng" : [206, 499],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B04'}
	},
	{
		"latlng" : [165, 499],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B05'}
	},
	{
		"latlng" : [124, 499],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B06'}
	},
	{
		"latlng" : [378, 556],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B07'}
	},
	{
		"latlng" : [337, 556],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B08'}
	},
	{
		"latlng" : [296, 556],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B09'}
	},
	{
		"latlng" : [206, 556],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B10'}
	},
	{
		"latlng" : [165, 556],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B11'}
	},
	{
		"latlng" : [124, 556],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B12'}
	},
	{
		"latlng" : [378, 595],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B13'}
	},
	{
		"latlng" : [337, 595],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B14'}
	},
	{
		"latlng" : [296, 595],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B15'}
	},
	{
		"latlng" : [206, 595],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B16'}
	},
	{
		"latlng" : [165, 595],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B17'}
	},
	{
		"latlng" : [124, 595],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B18'}
	},
	{
		"latlng" : [378, 651],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B19'}
	},
	{
		"latlng" : [337, 651],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B20'}
	},
	{
		"latlng" : [296, 651],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B21'}
	},
	{
		"latlng" : [206, 651],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B22'}
	},
	{
		"latlng" : [165, 651],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B23'}
	},
	{
		"latlng" : [124, 651],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B24'}
	},
	{
		"latlng" : [378, 690],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B25'}
	},
	{
		"latlng" : [337, 690],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B26'}
	},
	{
		"latlng" : [296, 690],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B27'}
	},
	{
		"latlng" : [206, 690],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B28'}
	},
	{
		"latlng" : [165, 690],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B29'}
	},
	{
		"latlng" : [124, 746],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B30'}
	},
	{
		"latlng" : [378, 746],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B31'}
	},
	{
		"latlng" : [337, 746],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B32'}
	},
	{
		"latlng" : [296, 746],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B33'}
	},
	{
		"latlng" : [206, 746],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B34'}
	},
	{
		"latlng" : [165, 746],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B35'}
	},
	{
		"latlng" : [124, 690],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B36'}
	},
	// 오픈형 - 사선부
	{
		"latlng" : [380, 783],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B37'}
	},
	{
		"latlng" : [326, 792],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B38'}
	},
	{
		"latlng" : [404, 824],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B39'}
	},
	{
		"latlng" : [350, 833],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B40'}
	},
	{
		"latlng" : [374, 863],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B41'}
	},
	{
		"latlng" : [272, 781],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B42'}
	},
	{
		"latlng" : [218, 790],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B43'}
	},
	{
		"latlng" : [296, 822],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B44'}
	},
	{
		"latlng" : [242, 831],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B45'}
	},
	{
		"latlng" : [157, 783],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B46'}
	},
	{
		"latlng" : [103, 792],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B47'}
	},
	{
		"latlng" : [181, 824],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B48'}
	},
	{
		"latlng" : [127, 833],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B49'}
	},
	{
		"latlng" : [325, 864],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B50'}
	},
	{
		"latlng" : [271, 873],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B51'}
	},
	{
		"latlng" : [349, 905],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B52'}
	},
	{
		"latlng" : [295, 914],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B53'}
	},
	{
		"latlng" : [210, 866],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B54'}
	},
	{
		"latlng" : [156, 875],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B55'}
	},
	{
		"latlng" : [234, 907],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B56'}
	},
	{
		"latlng" : [180, 916],
		"option" : {color:'green',radius:15,offCd:'3FOPEN',offLoc:'A304',srNo:'B57'}
	}
];

var today = toStringByFormatting(new Date());

// 예약된 좌석 정보 가져오기
var firstRequest = $.ajax({
	type: "post",
	url: "/rsv/rsvseatdata.do",
	data: JSON.stringify({"srDate" : today}),
	contentType: "application/json; charset=utf-8"
});
firstRequest.done(function(firstData){
	console.log(firstData);
	for (var j = 0; j < firstData.length; j++) {
		for (var i = 0; i < circles.length; i++) {
		    if (circles[i].option.offCd == firstData[j].offCd && circles[i].option.srNo == firstData[j].srNo) {
		        circles[i].option.color = 'red';
		    }
		}
	}
	// 예약 불가 좌석 정보 가져오기
	var secondRequest = $.ajax({
		type: "post",
		url: "/rsv/blockseatdata.do",
		data: JSON.stringify({"srDate" : today}),
		contentType: "application/json; charset=utf-8"
	});
	secondRequest.done(function(secondData){
		console.log(secondData);
		for (var j = 0; j < secondData.length; j++) {
			for (var i = 0; i < circles.length; i++) {
			    if (circles[i].option.offCd == secondData[j].offCd && circles[i].option.srNo == secondData[j].srNo) {
			        circles[i].option.color = 'black';
			    }
			}
		}
		
		circles.forEach(function(circleInfo){
			var circle = L.circle(circleInfo.latlng, circleInfo.option).addTo(map).on("click", circleClick);
			if(circleInfo.option.color == 'red'){
				circle.bindPopup('이미 예약된 좌석입니다.');
			} else if(circleInfo.option.color == 'black'){
				circle.bindPopup('관리자에 의해 예약불가 처리된 좌석입니다.');
			} else{
				circle.bindPopup('선택한 좌석 : ' + circleInfo.option.srNo);
			}
		});
	});
	
});

// var baseMaps = {
// 	"21F": L.imageOverlay('21F Image Link', bounds),
// 	"22F": L.imageOverlay('22F Image Link', bounds),
// 	"23F": L.imageOverlay('22F Image Link', bounds)
// }
// L.control.layers(baseMaps).addTo(map);

// map.on("baselayerchange", (event) => {
// 	console.log(event.name); // 변경 후의 층수를 출력한다.
// 	// 층별 처리를 구현한다.
// });

// map.addLayer(baseMaps["21F"]);

map.fitBounds(bounds); // 표현 영역을 설정한다

map.on('click', function(e) {
    console.log(e);
    console.log("e.latlng.lat : " + e.latlng.lat + ", e.latlng.lng : " + e.latlng.lng);
});

function circleClick(e) {
	var clickedCircle = e.target;
	console.log(e);
	console.log(e.sourceTarget.options.color);
	if(e.sourceTarget.options.color == 'red' || e.sourceTarget.options.color == 'black'){
		return;
	}
	
	console.log(e.sourceTarget.options.offCd);
	console.log(e.sourceTarget.options.srNo);
	$("#offCdPlace").text(e.sourceTarget.options.offCd.substr(0,2) + " " + e.sourceTarget.options.offLoc);
	$("#srNoPlace").text(e.sourceTarget.options.srNo);
	var offSe;
	switch(e.sourceTarget.options.offCd.substr(2)){
		case 'OPEN' : offSe = '오픈형'; break;
		case 'IMMER' : offSe = '몰입형'; break;
		case 'TEAM' : offSe = '협업형'; break;
	}
	$("#offSePlace").text(offSe);
	
	$("#hiddenPlace").text("");
	$("#hiddenPlace").append(`<input type="hidden" name="offCd" value="`+e.sourceTarget.options.offCd+`">`);
	$("#hiddenPlace").append(`<input type="hidden" name="srNo" value="`+e.sourceTarget.options.srNo+`">`);
	
	// do something, like:
// 	clickedCircle.bindPopup("some content").openPopup();
}

//Date 타입 변환 함수 시작 //
function leftPad(value) {
    if (value >= 10) {
        return value;
    }

    return `0\${value}`;
}

function toStringByFormatting(source, delimiter = '-') {
    const year = source.getFullYear();
    const month = leftPad(source.getMonth() + 1);
    const day = leftPad(source.getDate());

    return [year, month, day].join(delimiter);
}
// Date 타입 변환 함수 끝 //
</script>

