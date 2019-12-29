package net.lsun.servlet;

import com.aliyuncs.CommonRequest;
import com.aliyuncs.CommonResponse;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "SendSms", value = "/send_sms")
public class SendSms extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter printWriter = response.getWriter();

        String phone = request.getParameter("phone");

        final String accessKeyId = "LTAI4Fduaiqwbu4ooEJwSt9Y";
        final String accessKeySecret = "1LJCl7lgAUNbb9rNMXA37CFq87slYG";

        DefaultProfile profile = DefaultProfile.getProfile("cn-hangzhou", accessKeyId, accessKeySecret);
        IAcsClient client = new DefaultAcsClient(profile);

        CommonRequest req = new CommonRequest();
        req.setSysMethod(MethodType.POST);
        req.setSysDomain("dysmsapi.aliyuncs.com");
        req.setSysVersion("2017-05-25");
        req.setSysAction("SendSms");
        req.putQueryParameter("RegionId", "cn-hangzhou");
        req.putQueryParameter("PhoneNumbers", phone);
        req.putQueryParameter("SignName", "171快乐源泉");
        req.putQueryParameter("TemplateCode", "SMS_181211375");

        String code = (Math.random() + "").substring(2, 8);
        req.putQueryParameter("TemplateParam", "{\"code\":\"" + code + "\"}");

        System.out.println("code=" + code);

        try {
            CommonResponse res = client.getCommonResponse(req);
            printWriter.write("{\"success\":true,\"msg\":\"发送成功\",\"data\":" + res.getData() + "}");
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("code", code);
            System.out.println(res.getData());
        } catch (ClientException e) {
            printWriter.write("{\"success\":false,\"msg\":\"发送失败\",\"data\":{}}");
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
