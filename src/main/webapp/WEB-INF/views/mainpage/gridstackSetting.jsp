<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/9.2.2/gridstack.min.css" integrity="sha512-c0A8wU7VMWZRt4qqDc+AxarWQ2XFsQcrJGABe1eyCNxNfj2AI4+YYTytjGlHdrSk7HxA4jHakbXLzw/O/W5WmA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/9.2.2/gridstack-extra.min.css" integrity="sha512-287EQpO1sItRDNvuCUARDlhpQs3qLRCMaidpOKp5BFu6EgcX3XxB92jmTvdXWW57Q9ImHcYqIHKx12EATT3sPA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<script type="module" src="https://unpkg.com/ionicons@4.5.10-0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule="" src="https://unpkg.com/ionicons@4.5.10-0/dist/ionicons/ionicons.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/9.2.2/gridstack-all.min.js" integrity="sha512-5HTU6mahI/Gm/8o09h6r4B4mTypnVZnM0VgWqLVKJDgBxqbxt7JTqraIdGINJ3fp/5ek/k73kmAE6UitSWPZhw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<style type="text/css">
  .grid-stack { background: #FAFAD2; }
  .grid-stack-item-content { background-color: #F0E68C; text-align: center; font-size: 25px; }
  .grid-stack-item-removing {
    opacity: 0.8;
    filter: blur(5px);
  }
  #trash {
    background: rgba(255, 0, 0, 0.4);
  }
</style>

<sec:authentication property='principal.emp.empNo' var="empNo"/>

<div class="row" id="empNoInfo" data-empno="${empNo }">
	<div class="col-md-2">
   		<a class="btn btn-info me-1 mb-1" onClick="saveFullGrid()" href="#">저장</a>
   		<sec:authorize access="hasRole('ROLE_ADMIN')">
   			<a class="btn btn-outline-info me-1 mb-1" href="/adminmain.do">취소</a>
   		</sec:authorize>
   		<sec:authorize access="hasRole('ROLE_MEMBER')">
   			<a class="btn btn-outline-info me-1 mb-1" href="/">취소</a>
   		</sec:authorize>
   		<hr>
    	<h3>포틀릿 목록</h3><br>
    	<sec:authorize access="hasRole('ROLE_MEMBER')">
    	<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('attend')" href="#">근태</a><br>
    	</sec:authorize>
   		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('todolist')" href="#">to-do list</a><br>
   		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('schedule')" href="#">일정</a><br>
   		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('task')" href="#">업무</a><br>
   		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('auth')" href="#">결재</a><br>
   		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('mail')" href="#">메일</a><br>
<!--    		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('chat')" href="#">채팅</a><br> -->
   		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('addr')" href="#">주소록</a><br>
   		<a class="btn btn-soft-info me-1 mb-1" onClick="addCategory('board')" href="#">게시판</a><br>
<!-- 		<div id="trash" style="padding: 5px; margin-bottom: 15px;" class="text-center"> -->
<!-- 			<div> -->
<!-- 				<ion-icon name="trash" style="font-size: 300%"></ion-icon> -->
<!-- 			</div> -->
<!-- 			<div> -->
<!-- 				<span>드래그해서 지우기</span> -->
<!-- 	      	</div> -->
<!--     	</div> -->
	</div>
	<div class="col-md-10">
		<div class="grid-stack">
		<c:if test="${!empty portletList}">
			<c:forEach items="${portletList}" var="portlet">
			  <div class="grid-stack-item" gs-id="${portlet.portCatecode }" gs-x="${portlet.portXcoord }" gs-y="${portlet.portYcoord }" gs-w="${portlet.portWidth }" gs-h="${portlet.portHeight }" gs-no-resize="true">
			    <div class="grid-stack-item-content">
			    	<br>
			    	<button class="btn btn-outline-warning me-1 mb-1" onclick="removeWidget(this.parentElement.parentElement)">X</button>
			    	<br><br>
			    	<!-- 메뉴 이름 -->
			    </div>
			  </div>
			</c:forEach>
		</c:if>
		</div>
	</div>
</div>
<!-- <input type="hidden"> 폼으로 감싸서 보내기 -->


<script type="text/javascript">

let grid;

window.onload = function(){
    grid = GridStack.init({
   	  minRow: 1, // don't let it collapse when empty
      cellHeight: 70, // initial / auto
//       sizeToContent: true, // default to make them all fit
      acceptWidgets: true,
      removable: '#trash', // drag-out delete class
      disableOneColumnMode: true,
    });

//     let items = [
//     	{content: 'my first widget'}, // will default to location (0,0) and 1x1
// 		{w: 2, content: 'another longer widget!'} // will be placed next at (1,0) and 2x1
//     ];
//     grid.load(items);
    
	let gridList = document.querySelectorAll('.grid-stack-item');
	
	for(let i=0; i<gridList.length; i++){
	    let menu = gridList[i].getAttribute('gs-id');
	    console.log(menu);
	    
	    let menuName;
	    switch (menu) {
	        case 'attend': menuName = '근태'; break;
	        case 'mail': menuName = '메일'; break;
	        case 'chat': menuName = '채팅'; break;
	        case 'addr': menuName = '주소록'; break;
	        case 'schedule': menuName = '일정'; break;
	        case 'task': menuName = '업무'; break;
	        case 'auth': menuName = '결재'; break;
	        case 'board': menuName = '게시판'; break;
	        case 'todolist': menuName = 'to-do list'; break;
    	}
	    
	    console.log(menuName);
	    gridList[i].children[0].innerHTML += menuName;
	}
    
    grid.on('added removed change', function(e, items) {
      let str = '';
      items.forEach(function(item) { str += ' (x,y)=' + item.x + ',' + item.y; });
      console.log(e.type + ' ' + items.length + ' items:' + str );
    });
}

function addCategory(menu) {
// 	console.log(menu)
//  grid.addWidget({x:0, y:50, w:6, h:4, id:menu, content:menuName, noResize:true});
 	
 	if (document.querySelector('div[gs-id="' + menu + '"]')) {
 		return;
 	}
 	
 	let menuName = event.target.innerText;
 	console.log(menuName);

//  fetchHtmlAsText("/grid/" + menu).then(function (htmlText) { // 아이프레임 형식 -> 세팅에서 굳이 내용까지 보여줄 필요 없음
// 	console.log(htmlText);
	 		
	  	let newDiv = document.createElement("div");
	  	newDiv.setAttribute('gs-id', menu);
	  	newDiv.setAttribute('gs-w', 6);
	  	newDiv.setAttribute('gs-h', 6);
	  	newDiv.setAttribute('gs-no-resize', true);
	  	newDiv.innerHTML = `
	  		<div class="grid-stack-item-content">
		    	<br>
		    		<button class="btn btn-outline-warning me-1 mb-1" onclick="removeWidget(this.parentElement.parentElement)">X</button>
		    	<br><br>`
		    	+ menuName +
	    	`</div>`;
		grid.el.appendChild(newDiv);
		grid.makeWidget(newDiv);
		
//  });
}
    
async function fetchHtmlAsText(url) {
	console.log("요청 url : " + url);
	const response = await fetch(url);
    return await response.text();
}

function saveFullGrid() {
	serializedFull = grid.save(false, false); // grid.save(content, option);
    let data = JSON.stringify(serializedFull, null, ' ');
    console.log(data);

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/savegrid.do", false); // 동기
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(data);
    
    if (xhr.status == 200) {
    	if($("#empNoInfo").data("empno") == 'admin'){
    		window.location.href = "/adminmain.do";
    	} else{
	    	window.location.href = "/";
    	}
    }
}

function removeWidget(el) {
    // TEST removing from DOM first like Angular/React/Vue would do
    el.remove();
    grid.removeWidget(el, false);
}

</script>
