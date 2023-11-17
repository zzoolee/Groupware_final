package kr.or.ddit.controller.chat;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.security.CustomUser;
import kr.or.ddit.service.IChatService;
import kr.or.ddit.vo.ChatRoomDTLVO;
import kr.or.ddit.vo.ChatVO;
import kr.or.ddit.vo.chatSelectResultVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ChatController {

   @Inject
   private IChatService service;
   
   @RequestMapping(value="/chatMain.do", method=RequestMethod.GET)
   public String ChatMain(Model model) {
	  log.info("ChatMain()실행...!");
      CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      String chatuser = user.getEmp().getEmpNo();
      List<chatSelectResultVO> chatList = service.selectChatUser(chatuser);
      log.info("chatList : {}",chatList);
      
      model.addAttribute("chatList", chatList);
      return "main/chat/chatMain";
   }
   
//   @RequestMapping(value = "/selectChatRoom", method = RequestMethod.GET)
//   public String selectChatRoom(Model model, Principal principal) {
//      log.info("selectChat() 실행....!");
//      CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//      String chatuser = user.getEmp().getEmpNo();
//      log.info("chatuser : {}" , chatuser);
//      List<chatSelectResultVO> chatlist = service.selectChatRoom(chatuser);
//      model.addAttribute("chatlist", chatlist);
//      log.info("room : " + chatlist);
//      return "main/chat/chatMain";`
//   }

   @ResponseBody
   @RequestMapping(value = "/selectChatRoom", method = RequestMethod.POST)
   public ResponseEntity<?> selectChatRoom(){
      log.info("selectChatRoom() 실행...!");
      CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      String chatuser = user.getEmp().getEmpNo();
      
      List<chatSelectResultVO> chatList = service.selectChatRoom(chatuser);
      log.info("chatList : {}" ,chatList);
      return new ResponseEntity<>(chatList,HttpStatus.OK);
   }
   
//   @RequestMapping(value = "/selectChatUser", method = RequestMethod.GET)
//   public String selectChatUser(Model model, Principal principal) {
//      log.info("selectChatUser() 실행...!");
//      CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//      String chatuser = user.getEmp().getEmpNo();
//      List<chatSelectResultVO> chatlist = service.selectChatUser(chatuser);
//      model.addAttribute("chatlist", chatlist);
//      log.info("user : " + chatlist);
//      return "main/chat/chatMain";
//   }
   @ResponseBody
   @RequestMapping(value = "/selectChatUser", method = RequestMethod.POST)
   public ResponseEntity<?> selectChatUser(){
      log.info("selectChatUser() 실행...!");
      CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      String chatuser = user.getEmp().getEmpNo();
      List<chatSelectResultVO> chatList = service.selectChatUser(chatuser);
      log.info("chatList : {}" ,chatList);
      return new ResponseEntity<>(chatList,HttpStatus.OK);
   }
   
   @ResponseBody
   @RequestMapping(value = "/groupChat", method = RequestMethod.POST)
   public ResponseEntity<?> groupChat(@RequestBody String[] empNoList){
      
      for (String empNo : empNoList) {
            log.info("empNo 그룹챗 : {}", empNo);
        }
      log.info("createChatGroupRoom() 실행...! : {}", empNoList);
      service.createChatGroupRoom(empNoList);
      log.info("createChatMyMember() 실행...!");
      service.createchatMyMember();
      log.info("createChatGroupMember() 실행...!");
      service.createChatGroupMember(empNoList);
      
      return new ResponseEntity<>(HttpStatus.OK);
   }
   
   @ResponseBody
   @RequestMapping(value = "/checkChat", method=RequestMethod.POST)
   public ResponseEntity<?> checkChat(@RequestBody Map<String, String> requestBody, Principal principal) {
       log.info("checkChat() 실행...!");
       log.info("requestBody : {}" +requestBody);
      String empNo = requestBody.get("empNo");
       String crNo = requestBody.get("crNo");
       ChatVO chat = new ChatVO();
       // 채팅방이 존재하는지 확인
       if(StringUtils.isBlank(crNo)) {
          boolean chatRoomExists = service.checkChatRoomExists(empNo);
          log.info("채팅방 존재 유무 확인 : {}",chatRoomExists);
          if (chatRoomExists == false) {
             // 채팅방이 존재하지 않는 경우 생성
             log.info("createChatMyRoom() 실행...!");
             service.createChatMyRoom(empNo);
//             service.insertCcFirst(empNo);
             log.info("createchatMyMember() 실행...!");
             service.createchatMyMember();
             log.info("createChatMember() 실행...!");
             service.createChatMember(empNo);
             crNo = service.selectcrNo(empNo);
             log.info("selectcrNo()실행...! : {}",crNo);
          }
       }
       log.info("crNo 확인용 : {}",crNo );
       chat.setCrNo(crNo);
       log.info("crNo!!! : {}",crNo);
       List<ChatRoomDTLVO> chatRoomDtlList = service.selectRoomDetail(chat);
       log.info("chatRoomDtlList : {}" , chatRoomDtlList);
       if(chatRoomDtlList != null) {
          for(int i = 0; i < chatRoomDtlList.size(); i++) {
             String roomCrNo = chatRoomDtlList.get(i).getCrNo();
             String userEmpNo = principal.getName();
             String roomTitle = service.selectChatRoomTitle(roomCrNo,userEmpNo);
             log.info("roomTitle : {}",roomTitle );
             chatRoomDtlList.get(i).setCrcmTitle(roomTitle);
             log.info("chatRoomDtlList() 실행..! : {}",chatRoomDtlList);
          }
       }
       if (chatRoomDtlList != null && !chatRoomDtlList.isEmpty()) {
//          // 성공하면
           return new ResponseEntity<>(chatRoomDtlList, HttpStatus.OK);
       } else {
          // 실패하면
          ChatRoomDTLVO vo =  new ChatRoomDTLVO();
          vo.setCrNo(crNo);
          chatRoomDtlList.add(vo);
          String userEmpNo = principal.getName();
          String roomTitle = service.selectChatRoomTitle(crNo,userEmpNo);
          log.info("roomTitle : {}",roomTitle );
          vo.setCrcmTitle(roomTitle);
          log.info("chatRoomDtlList() 실행..! : {}",chatRoomDtlList);
           return new ResponseEntity<>(chatRoomDtlList, HttpStatus.OK);
       }
   }
   
   /**
    * 미확인 채팅 갯수 가져오기
    * @param principal empNo
    * @return int 미확인 알람갯수
    */
   // Map으로 받음
   @ResponseBody
   @PostMapping("/selectUnreadChat.do")
   public int selectUnreadChat (@RequestBody Map<String, String> map) {
      String empNo = map.get("empNo");
      log.info("selectUnreadChat:{}",empNo);
      int cnt = service.selectUnreadChat(empNo);
      
      return cnt;
   }
   
   @ResponseBody
   @PostMapping(value = "/crcmModify.do")
   public Map<String, Object> crcmModify(@RequestBody Map<String, String> map) {
	   log.info("crcmModify() 실행...!");
	   String crcmTitle = map.get("crcmTitle");
	   String crNo = map.get("crNo");
	   CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	   String chatuser = user.getEmp().getEmpNo();
	   service.crcmModify(crcmTitle, crNo);
	   String newCrcmTitle = service.newTitleselect(crNo);
	   List<chatSelectResultVO> chatList = service.selectChatRoom(chatuser);
	   log.info("newCrcmTitle : {}",newCrcmTitle);
	   Map<String, Object> responseData = new HashMap<String, Object>();
	   responseData.put("crcmTitle", newCrcmTitle);
	   responseData.put("chatList", chatList);
	   return responseData;
   }
   
   @ResponseBody
   @PostMapping(value = "/searchChat.do")
   public List<chatSelectResultVO> searchChat(@RequestBody Map<String, String> requestData){
	   String keyword = requestData.get("keyword");
	    String tab = requestData.get("tab");
	    //search() 실행...! 키워드: 지성, 탭: user
	    log.info("search() 실행...! 키워드: {}, 탭: {}", keyword, tab);

	    return service.selectChatSearch(keyword, tab);
   }
   
   @ResponseBody
   @PostMapping(value = "/getUserList.do")
   public List<chatSelectResultVO> getUserList(@RequestBody Map<String, String> requestData){
	   String crNo = requestData.get("crNo");
	   log.info("searchChat()실행...! : {}", crNo);
	   return service.selectUserNameList(crNo);
   }
   
}
//   @ResponseBody
//   @RequestMapping(value = "/selectRoomDetail", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
//   public ResponseEntity<List<ChatRoomDTLVO>> selectRoomDetail(@RequestBody Map<String, String> requestBody){
//      log.info("selectRoomDetail() 실행....!");
//
//       String crNo = requestBody.get("crNo");
//       
//       ChatVO chat = new ChatVO();
//       chat.setCrNo(crNo);
//       
//       // 채팅방 상세보기 
//       log.info("crNo: " + crNo);
//       List<ChatRoomDTLVO> chatRoomDtlList = service.selectRoomDetail(chat);
//       log.info("chasender_EMPNO: " + chat.getChasenderEmpno());
//
//       if (chatRoomDtlList != null && !chatRoomDtlList.isEmpty()) {
//           // 성공했을 때
//           return new ResponseEntity<>(chatRoomDtlList, HttpStatus.OK);
//       } else {
//           // 실패하면 404
//           return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//       }
//   }
//   
//   @ResponseBody
//    @RequestMapping(value = "/createChat", method = RequestMethod.POST)
//    public ResponseEntity<ChatRoomVO> createChat(@RequestBody List<String> empNolist, @RequestBody(required = false) String crNo) {
//        service.createChatMyRoom(empNolist);
//        service.createChatMember(empNolist, crNo);
//        return new ResponseEntity<>(HttpStatus.CREATED);
//    }

//   @ResponseBody
//   @RequestMapping(value = "/insertChat", method = RequestMethod.POST)
//   public ResponseEntity<String> insertChat(@RequestParam("chatMsg") String chatMsg) {
//      log.info("insertChat() 실행...!");
//      log.info("chatMsg : " + chatMsg);
//      // 채팅 저장기능을 요청
//      service.insertChatting(chatMsg);
//      return ResponseEntity.ok("메세지 전송 성공");
//   }
   