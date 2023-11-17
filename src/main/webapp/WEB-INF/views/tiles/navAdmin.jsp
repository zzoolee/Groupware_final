<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set value="text-info fw-bold" var="focus"/>
      <nav class="navbar navbar-vertical navbar-expand-lg navbar-darker">
        <script>
          var navbarStyle = window.config.config.phoenixNavbarStyle;
          if (navbarStyle && navbarStyle !== 'transparent') {
            document.querySelector('body').classList.add(`navbar-${navbarStyle}`);
          }
        </script>
        <div class="collapse navbar-collapse" id="navbarVerticalCollapse">
          <!-- scrollbar removed-->
          <div class="navbar-vertical-content">
            <ul class="navbar-nav flex-column" id="navbarVerticalNav">
              <li class="nav-item">
                <!-- parent pages-->
                <div class="nav-item-wrapper">
                  <div class="nav-item-wrapper">
                  	<a class="nav-link label-1" href="/adminmain.do" role="button" data-bs-toggle="" aria-expanded="false">
                    	<div class="d-flex align-items-center">
                    		<span class="uil uil-home fs-1"></span>
                    		<span class="nav-link-icon">
                    			<span class="nav-link-text">&nbsp;&nbsp;&nbsp;Home</span>
                    		</span>
                    	</div>
                  	</a>
                  </div>
                </div>
                <!-- parent pages-->
                
              </li>
              <li class="nav-item">
                <!-- label-->
<!--                 <p class="navbar-vertical-label">Apps -->
                </p>
                <hr class="navbar-vertical-line" />
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-userAdm" role="button" data-bs-toggle="collapse" aria-expanded="${not empty empBar}" aria-controls="nv-userAdm">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-users-alt fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;계정관리</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty empBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-userAdm">
                      <li class="collapsed-nav-item-title d-none">userAdm
                      </li>
                      <li class="nav-item">
                     	 <a class="nav-link" href="${pageContext.request.contextPath }/adminEmpList.do" data-bs-toggle="" aria-expanded="false">
                         	 <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty empBar1}'>${focus }</c:if>">계정목록</span> </div>
                        </a>
                      </li>

                      <li class="nav-item">
                     	 <a class="nav-link" href="${pageContext.request.contextPath }/adminEmpRegister.do" data-bs-toggle="" aria-expanded="false">
                         	 <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty empBar2}'>${focus }</c:if>">계정생성</span> </div>
                        </a>
                      </li>
                      
                    </ul>
                  </div>
                </div>
                
                
                <!-- parent pages-->
                <div class="nav-item-wrapper">
                <a class="nav-link dropdown-indicator label-1" href="#nv-empAdm" role="button" data-bs-toggle="collapse" aria-expanded="${not empty attendBar}" aria-controls="nv-empAdm">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-users-alt fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;직원관리</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty attendBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-empAdm">
                      <li class="collapsed-nav-item-title d-none">empAdm
                      </li>
                      <li class="nav-item">
                     	 <a class="nav-link " href="/adminattend.do" data-bs-toggle="" aria-expanded="false">
                         	 <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty attendBar1}'>${focus }</c:if>">근태관리</span> </div>
                        </a>
                      </li>

                      <li class="nav-item">
                     	 <a class="nav-link" href="/adminAyann.do" data-bs-toggle="" aria-expanded="false">
                         	 <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty attendBar2}'>${focus }</c:if>">연차관리</span> </div>
                        </a>
                      </li>
                      
                      <li class="nav-item">
                     	 <a class="nav-link" href="${pageContext.request.contextPath }/docmanage.do" data-bs-toggle="" aria-expanded="false">
                         	 <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty attendBar3}'>${focus }</c:if>">급여명세서관리</span></div>
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-events" role="button" data-bs-toggle="collapse" aria-expanded="${not empty taskBar}" aria-controls="nv-events">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-archive fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;업무</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty taskBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-events">
                      <li class="collapsed-nav-item-title d-none">업무
                      </li>
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/adminTask.do" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty taskBar1}'>${focus }</c:if>">업무현황</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-kanban" role="button" data-bs-toggle="collapse" aria-expanded="${not empty draftBar}" aria-controls="nv-kanban">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-check fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;결재</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty draftBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-kanban">
                      <li class="collapsed-nav-item-title d-none">결재
                      </li>
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/draft.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar1}'>${focus }</c:if>">완료기안서</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/admin/draftmanage.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar2}'>${focus }</c:if>">기안양식폼관리</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-email" role="button" data-bs-toggle="collapse" aria-expanded="${not empty mailBar}" aria-controls="nv-email">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-envelope-alt fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;메일</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty mailBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-email">
                      <li class="collapsed-nav-item-title d-none">Email
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/sendmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar1}'>${focus }</c:if>">메일보내기</span>
                          </div>
                        </a>
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/receivedmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar2}'>${focus }</c:if>">받은메일함</span>
                          </div>
                        </a>
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/sendedmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar3}'>${focus }</c:if>">보낸메일함</span>
                          </div>
                        </a>
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/receivedmyselfmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar4}'>${focus }</c:if>">내게쓴메일함</span>
                          </div>
                        </a>
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/importantmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar5}'>${focus }</c:if>">중요메일함</span>
                          </div>
                        </a>
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/deletedmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar6}'>${focus }</c:if>">휴지통</span>
                          </div>
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
                
                
                <!-- parent pages-->
         		<!-- <div class="nav-item-wrapper"><a class="nav-link label-1" href="apps/chat.html" role="button" data-bs-toggle="" aria-expanded="false">
                    <div class="d-flex align-items-center"><span class="nav-link-icon"><span data-feather="message-square"></span></span><span class="nav-link-text-wrapper"><span class="nav-link-text">채팅</span></span>
                    </div>
                  </a>
                </div> -->
                
                <!-- parent pages-->
				<div class="nav-item-wrapper">
						<a class="nav-link label-1" href="/chatMain.do"
							role="button" data-bs-toggle="" aria-expanded="false">
							<div class="d-flex align-items-center">
								<span class="uil uil-chat fs-1"></span> 
								<span class="nav-link-text-wrapper"> 
							<span class="nav-link-text <c:if test='${not empty chatBar}'>${focus }</c:if>">&nbsp;&nbsp;&nbsp;채팅</span></span>
						</div> 
					</a>
				</div>

                
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-project-management" role="button" data-bs-toggle="collapse" aria-expanded="${not empty addBar}" aria-controls="nv-project-management">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-phone fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;주소록</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty addBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-project-management">
                      <li class="collapsed-nav-item-title d-none">주소록
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/add/admin.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty addBar1}'>${focus }</c:if>">전사주소록</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link label-1" href="/admin/schedule.do" role="button" data-bs-toggle="" aria-expanded="false">
                    <div class="d-flex align-items-center"><span class="uil uil-calender fs-1"></span><span class="nav-link-text-wrapper"><span class="nav-link-text <c:if test='${not empty scheduleBar}'>${focus }</c:if>">&nbsp;&nbsp;&nbsp;일정</span></span>
                    </div>
                  </a>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-social" role="button" data-bs-toggle="collapse" aria-expanded="${not empty fileBar}" aria-controls="nv-social">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-folder fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;자료실</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty fileBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-social">
                      <li class="collapsed-nav-item-title d-none">자료실
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/adminComfiles.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty fileBar1}'>${focus }</c:if>">전사자료실</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/adminDepfiles.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty fileBar2}'>${focus }</c:if>">부서자료실</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                
              </li>
              <li class="nav-item">
                <!-- label-->
<!--                 <p class="navbar-vertical-label">Pages -->
<!--                 </p> -->
                <hr class="navbar-vertical-line" />
                
               
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-landing22" role="button" data-bs-toggle="collapse" aria-expanded="${not empty resBar}" aria-controls="nv-landing">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-check-circle fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;예약관리</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty resBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-landing22">
                      <li class="collapsed-nav-item-title d-none">예약
                      </li>
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/admin/room.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar1}'>${focus }</c:if>">회의실예약관리</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/admin/asset.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar2}'>${focus }</c:if>">자산대여관리</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/rsv/freeseatadmin.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar3}'>${focus }</c:if>">자율좌석예약관리</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/admin/rsvlist.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar4}'>${focus }</c:if>">예약현황</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-landing" role="button" data-bs-toggle="collapse" aria-expanded="${not empty boardBar}" aria-controls="nv-landing">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-globe fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;커뮤니티</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty boardBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-landing">
                      <li class="collapsed-nav-item-title d-none">Landing
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/noticemain.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar1}'>${focus }</c:if>">공지사항</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/freemain.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar2}'>${focus }</c:if>">자유게시판</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/feventmain.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar3}'>${focus }</c:if>">경조사게시판</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item">
                      	<a class="nav-link" href="/manageclub/admin.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center">
                            <span class="nav-link-text <c:if test='${not empty boardBar4}'>${focus }</c:if>">동호회관리</span>
                          </div>
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
                
              
              </li>
              
            </ul>
          </div>
        </div>
        <div class="navbar-vertical-footer">
          <button class="btn navbar-vertical-toggle border-0 fw-semi-bold w-100 white-space-nowrap d-flex align-items-center"><span class="uil uil-left-arrow-to-left fs-0"></span><span class="uil uil-arrow-from-right fs-0"></span><span class="navbar-vertical-footer-text ms-2">Collapsed View</span></button>
        </div>
      </nav>