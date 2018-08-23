using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class _404 : System.Web.UI.Page
{
    public string errorID { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.UrlReferrer != null)
        {
            ViewState["PreviousPageUrl"] = Request.UrlReferrer.ToString();
        }

        if (Request.QueryString["ex"] != null)
        {
            errorID = Request.QueryString["ex"].ToString();
            ltlFlagForFollowUp.Text = "Logged as " + errorID;        
            
        }
        else
        {
            string myID = PageExtensionMethods.getMyWindowsID().ToString();
            
        }
    }

    protected void btnErrorMessage_Click(object sender, EventArgs e)
    {
        //if (errorID.Length > 0)
        //{
        //    Helper my = new Helper();
        //    SqlCommand cmd = new SqlCommand("setErrorLog");
        //    cmd.Parameters.AddWithValue("@FollowUpFlag", 1);
        //    my.ExecuteDMLCommand(ref cmd, "", "S");
        //}
        throw new OverflowException("ParasParmar", new Exception("OverFlow Exception by Paras Parmar as Test"));
        

    }
}