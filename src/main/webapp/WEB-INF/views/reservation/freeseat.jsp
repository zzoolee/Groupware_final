<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 
whooping-banner
gift-items-banner
best-in-market-banner
 -->

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <title>CSS</title>
  <style>
    .gift-items-banner div {
	  transition: all 0.2s linear;
	}
	.gift-items-banner:hover div {
	  transform: scale(1.2);
	}
    </style>
</head>
<body>

	<div class="row g-3 mb-9">
	  <div class="col-12">
	    <div class="gift-items-banner w-100 rounded-3 overflow-hidden">
	      <div class="bg-holder z-index--1 product-bg" style="background-image:url(${pageContext.request.contextPath }/resources/assets/gw/focus.jpg);">
	      </div>
	      <!--/.bg-holder-->
	
<%-- 	      <div class="bg-holder z-index--1 shape-bg" style="background-image:url(${pageContext.request.contextPath }/resources/assets/img/e-commerce/whooping_banner_shape_2.png);background-position: bottom left;"> --%>
<!-- 	      </div> -->
	      <!--/.bg-holder-->
	
	      <div class="banner-text text-md-center light">
	        <h2 class="text-white fw-bolder fs-xl-4">5층 <span class="gradient-text">몰입형 </span><br class="d-md-none"> 152좌석</h2>
	      </div>
	  </div>
	  </div>
	  <div class="col-12 col-xl-6">
	    <div class="gift-items-banner w-100 rounded-3 overflow-hidden">
	      <div class="bg-holder z-index--1 banner-bg" style="background-image:url(${pageContext.request.contextPath }/resources/assets/gw/2115383.jpg);">
	      </div>
	      <!--/.bg-holder-->
	
	      <div class="banner-text text-md-center light">
	        <h2 class="text-white fw-bolder fs-xl-4">3층 <span class="gradient-text">오픈형 </span><br class="d-md-none"> 57좌석</h2>
	      </div>
	    </div>
	  </div>
	  <div class="col-12 col-xl-6">
	    <div class="gift-items-banner w-100 rounded-3 overflow-hidden">
	      <div class="bg-holder z-index--1 banner-bg" style="background-image:url(${pageContext.request.contextPath }/resources/assets/gw/team.jpg);">
	      </div>
	      <!--/.bg-holder-->
	
	      <div class="banner-text text-md-center light">
	        <h2 class="text-white fw-bolder fs-xl-4">3층 <span class="gradient-text">협업형 </span><br class="d-md-none"> 66좌석</h2>
	      </div>
	    </div>
	  </div>
	</div>
	
  </body>
</html>

