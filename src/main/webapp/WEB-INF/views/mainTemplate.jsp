<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>

<html lang="en-US" dir="ltr">

<!-- 컨트롤러 메소드 실행 후 판단 -->
<sec:authorize access="isAnonymous()">
	<script type="text/javascript">
		alert("로그인이 필요한 페이지입니다.");
		location.href = "/login";
	</script>
</sec:authorize>

  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" sizes="5x5" type="image/png" href="${pageContext.request.contextPath }/resources/assets/gw/IW_Logo.png"> 
	
    <!-- ===============================================-->
    <!--    Document Title-->
    <!-- ===============================================-->
    <title>I-WORKS</title>


    <!-- ===============================================-->
    <!--    Favicons-->
    <!-- ===============================================-->
    <link rel="shortcut icon" href="${pageContext.request.contextPath }/resources/assets/gw/IW_Logo.png" type="image/x-icon"/>
	<link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath }/resources/assets/gw/IW_Logo.png" >
	
<%--     <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath }/resources/assets/img/favicons/apple-touch-icon.png"> --%>
<%--     <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath }/resources/assets/img/favicons/favicon-32x32.png"> --%>
<%--     <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath }/resources/assets/img/favicons/favicon-16x16.png"> --%>
<%--     <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath }/resources/assets/img/favicons/favicon.ico"> --%>
<%--     <link rel="manifest" href="${pageContext.request.contextPath }/resources/assets/img/favicons/manifest.json"> --%>
<%--     <meta name="msapplication-TileImage" content="${pageContext.request.contextPath }/resources/assets/img/favicons/mstile-150x150.png"> --%>
    <meta name="theme-color" content="#ffffff">
    <script src="${pageContext.request.contextPath }/resources/vendors/imagesloaded/imagesloaded.pkgd.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/simplebar/simplebar.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/assets/js/config.js"></script>


    <!-- ===============================================-->
    <!--    Stylesheets-->
    <!-- ===============================================-->
    <!-- 캘린더 -->
    <link href="${pageContext.request.contextPath }/resources/vendors/fullcalendar/main.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath }/resources/vendors/flatpickr/flatpickr.min.css" rel="stylesheet">
    <!-- index -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"> <!-- 적용? -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@300;400;600;700;800;900&amp;display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath }/resources/vendors/simplebar/simplebar.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.8/css/line.css">
    <link href="${pageContext.request.contextPath }/resources/assets/css/theme-rtl.min.css" type="text/css" rel="stylesheet" id="style-rtl">
    <link href="${pageContext.request.contextPath }/resources/assets/css/theme.min.css" type="text/css" rel="stylesheet" id="style-default">
    <link href="${pageContext.request.contextPath }/resources/assets/css/user-rtl.min.css" type="text/css" rel="stylesheet" id="user-style-rtl">
    <link href="${pageContext.request.contextPath }/resources/assets/css/user.min.css" type="text/css" rel="stylesheet" id="user-style-default">
    <script>
      var phoenixIsRTL = window.config.config.phoenixIsRTL;
      if (phoenixIsRTL) {
        var linkDefault = document.getElementById('style-default');
        var userLinkDefault = document.getElementById('user-style-default');
        linkDefault.setAttribute('disabled', true);
        userLinkDefault.setAttribute('disabled', true);
        document.querySelector('html').setAttribute('dir', 'rtl');
      } else {
        var linkRTL = document.getElementById('style-rtl');
        var userLinkRTL = document.getElementById('user-style-rtl');
        linkRTL.setAttribute('disabled', true);
        userLinkRTL.setAttribute('disabled', true);
      }
    </script>
    <link href="${pageContext.request.contextPath }/resources/vendors/leaflet/leaflet.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath }/resources/vendors/leaflet.markercluster/MarkerCluster.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath }/resources/vendors/leaflet.markercluster/MarkerCluster.Default.css" rel="stylesheet">
    <!-- ckeditor -->
  	<script src="${pageContext.request.contextPath }/resources/ckeditor/ckeditor.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    
    <!-- ===============================================-->
    <!--    JavaScripts-->
    <!-- ===============================================-->
    <!-- index -->
    <script src="${pageContext.request.contextPath }/resources/vendors/popper/popper.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/bootstrap/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/acnchorjs/anchor.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/is/is.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/fontawesome/all.min.js"></script>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=window.scroll"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/list.js/list.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/feather-icons/feather.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/dayjs/dayjs.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/lodash/lodash.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/echarts/echarts.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/assets/js/phoenix.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/leaflet/leaflet.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/leaflet.markercluster/leaflet.markercluster.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/leaflet.tilelayer.colorfilter/leaflet-tilelayer-colorfilter.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/assets/js/ecommerce-dashboard.js"></script>
    
    <script src="${pageContext.request.contextPath }/resources/assets/js/crm-dashboard.js"></script>
    <!-- 캘린더 -->
    <script src="${pageContext.request.contextPath }/resources/vendors/fullcalendar/main.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/vendors/dayjs/dayjs.min.js"></script>
    <script src="${pageContext.request.contextPath }/resources/assets/js/calendar.js"></script>
    <!-- 차트 -->
    <script src="${pageContext.request.contextPath }/resources/assets/js/echarts-example.js"></script>
    <!-- ajax안에서 Date타입 객체 패턴 지정을 위한 스크립트 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
  </head>


  <body>

    <!-- ===============================================-->
    <!--    Main Content-->
    <!-- ===============================================-->
    <main class="main" id="top">
    
	<!-- nav 위치 -->
	<sec:authorize access="hasRole('ROLE_MEMBER')">
		<tiles:insertAttribute name="nav"/>
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<tiles:insertAttribute name="navAdmin"/>
	</sec:authorize>
	
	<!-- header 위치 -->
	<tiles:insertAttribute name="header"/>
		
	<!-- message 알림 -->
	<c:if test="${not empty message }">
		<script type="text/javascript">
			alert("${message}");
			<c:remove var="message" scope="request"/>
			<c:remove var="message" scope="session"/>
		</script>
	</c:if>

      <div class="content">
		<!-- content 위치 -->
		<tiles:insertAttribute name="content"/>	

		<!-- footer 위치 -->
		<tiles:insertAttribute name="footer"/>
      </div>
      <script>
        var navbarTopStyle = window.config.config.phoenixNavbarTopStyle;
        var navbarTop = document.querySelector('.navbar-top');
        if (navbarTopStyle === 'darker') {
          navbarTop.classList.add('navbar-darker');
        }

        var navbarVerticalStyle = window.config.config.phoenixNavbarVerticalStyle;
        var navbarVertical = document.querySelector('.navbar-vertical');
        if (navbarVertical && navbarVerticalStyle === 'darker') {
          navbarVertical.classList.add('navbar-darker');
        }
      </script>
      
	<!-- chat 위치 -->
	<tiles:insertAttribute name="chat"/>

    </main>
    <!-- ===============================================-->
    <!--    End of Main Content-->
    <!-- ===============================================-->

  </body>

</html>
