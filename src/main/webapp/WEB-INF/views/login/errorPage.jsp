<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>I-WORKS</title>
<link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.8/css/line.css">
<link href="${pageContext.request.contextPath }/resources/assets/css/theme-rtl.min.css" type="text/css" rel="stylesheet" id="style-rtl">
<link href="${pageContext.request.contextPath }/resources/assets/css/theme.min.css" type="text/css" rel="stylesheet" id="style-default">
<link href="${pageContext.request.contextPath }/resources/assets/css/user-rtl.min.css" type="text/css" rel="stylesheet" id="user-style-rtl">
<link href="${pageContext.request.contextPath }/resources/assets/css/user.min.css" type="text/css" rel="stylesheet" id="user-style-default">

<style>
body {
  margin: 0 0 0 0;
  padding: 0 0 0 0;
  overflow: hidden; /* 스크롤을 숨김 */
  postiion : relative;
}
img {
  width: 100%;
  height: 100%;
  object-fit: cover; /* 이미지를 화면에 맞춤 */
}
button {
  position: absolute;
  top: 500px;
  left : 100px;
}
</style>
</head>
<body>
	<img alt="" src="${pageContext.request.contextPath }/resources/assets/gw/errorPage.png">
	<button class="btn btn-lg btn-info" onclick="history.back();">돌아가기</button>
</body>
</html>