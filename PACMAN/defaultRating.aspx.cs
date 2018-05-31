using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;

public partial class defaultRating : System.Web.UI.Page
{
    DataTable dtEmp = new DataTable();
    Helper my = new Helper();
    private int MyEmpID { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp == null)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    //MyName = dtEmp.Rows[0]["First_Name"].ToString() + " " + dtEmp.Rows[0]["Middle_Name"].ToString() + " " + dtEmp.Rows[0]["Last_Name"].ToString();
                    //MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                    //int LevelID = Convert.ToInt32(dtEmp.Rows[0]["LevelIDnumber"].ToString());
                    //if (LevelID <= 80)
                    //    IsManager = 1;
                    //else
                    //    IsManager = 0;
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Default Rating";
            fillddlPeriod();
            fillEmpList();

        }
        else
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp != null && dtEmp.Rows.Count <= 0)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    //MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    //MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                    //int LevelID = Convert.ToInt32(dtEmp.Rows[0]["LevelIDnumber"].ToString());
                    //if (LevelID <= 80)
                    //    IsManager = 1;
                    //else
                    //    IsManager = 0;
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
        }

        string orginalUrl = HttpContext.Current.Request.Url.AbsolutePath;
        if (!PageExtensionMethods.AmIAllowedThisPage(MyEmpID, orginalUrl))
        {
            Response.Redirect("404.aspx");
        }

    }



    private void fillEmpList()
    {
        int Period = Convert.ToInt32(ddlPeriod.SelectedValue.ToString());
        string strSQL = "PMS.fillEmpReport";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@PeriodID", Period);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        gv_EmpList.DataSource = dt;
        gv_EmpList.DataBind();

    }


    protected void gv_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if (gv.Rows.Count > 0)
        {
            gv.UseAccessibleHeader = true;
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;

            gv.HeaderStyle.BorderStyle = BorderStyle.None;

            gv.BorderStyle = BorderStyle.None;
            gv.BorderWidth = Unit.Pixel(1);
        }
    }

    protected void ddlPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillEmpList();
    }

    private void fillddlPeriod()
    {
        string strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlPeriod.DataSource = dt;
        ddlPeriod.DataTextField = "Period";
        ddlPeriod.DataValueField = "PeriodID";
        ddlPeriod.DataBind();


        //ddlPeriod.SelectedIndex = 0;
    }

    protected void gv_EmpList_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridView gv = (GridView)sender;
        GridViewRow gvr = (GridViewRow)e.Row;
        if (gvr.RowIndex >= 0)// && e.Row.RowIndex == gv.EditIndex
        {
            Button btn = (Button)gvr.FindControlRecursive("btn_DRSubmit");
            DropDownList ddl = (DropDownList)gvr.FindControlRecursive("ddlSelectDefaultRating");
            TextBox tb = (TextBox)gvr.FindControlRecursive("txt_DRComments");

            if (gvr.Cells[14].Text.ToString() == "Submitted by RepMgr")
            {
                btn.Enabled = true;
            }
            else
            {
                btn.Enabled = false;
            }
            
            //string strsql = "select case when IsDefault=1 then FinalRating else 0 end as DefaultRating from pms.Eligibility";
            DataTable dt = gv.DataSource as DataTable;
            int EmpCode = Convert.ToInt32(gvr.Cells[gvr.GetGVCellUsingFieldName("Emp_ID")].Text.ToString());
            DataRow[] drs = dt.Select("EmpCode = " + EmpCode);
            DataRow dr = drs[0];
            string DefaultRating = dr["Defaultrating"].ToString();
            ddl.SelectedValue = DefaultRating;
            
        }

    }
    protected void btn_DRSubmit_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;
        int EmpCode = Convert.ToInt32(row.Cells[0].Text.ToString());
        int Period = Convert.ToInt32(ddlPeriod.SelectedValue.ToString());
        DropDownList ddl = (DropDownList)row.FindControlRecursive("ddlSelectDefaultRating");
        var Rating = ddl.Text.ToString();
        TextBox tb = (TextBox)row.FindControlRecursive("txt_DRComments");
        var Comments= tb.Text.ToString();

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[PMS].[giveDefaultRating]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PeriodID", Period);
        cmd.Parameters.AddWithValue("@EmpCode", EmpCode);
        cmd.Parameters.AddWithValue("@Rating", Rating);
        cmd.Parameters.AddWithValue("@Comments", Comments);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        //Button buton = (Button)row.FindControlRecursive("btn_DRSubmit");
        //btn.Enabled = false;
        //ddl.Enabled = false;
        //tb.Enabled = false;

        ddl.Text = Rating;
        fillEmpList();
    }
}