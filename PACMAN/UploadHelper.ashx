<%@ WebHandler Language="C#" Class="UploadHelper" %>


using System;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.IO;

public class UploadHelper : IHttpHandler
{
    
    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            foreach (string key in files)
            {
                HttpPostedFile file = files[key];
                string fileName = Path.GetFileName(file.FileName);

                fileName = context.Server.MapPath("~/Sitel/uploads/" + fileName);
                file.SaveAs(fileName);
            }
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write("File(s) uploaded successfully!");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}

