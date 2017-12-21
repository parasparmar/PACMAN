using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data.Sql;

public partial class pacman : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private int MyRepMgr { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

        if (!IsPostBack)
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp.Rows.Count <= 0)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "PACMAN";
            filltblKPI();
        }
    }

    private void filltblKPI()
    {
        string strSQL = "[WFMPMS].[getSLForEmpAndAccount_511TOT1]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", 803471);
        cmd.Parameters.AddWithValue("@StartDate", "20170820");
        cmd.Parameters.AddWithValue("@EndDate", "20170820");
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        tblKPI.DataSource = dt;
        tblKPI.DataBind();

    }
}