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

public partial class period : System.Web.UI.Page
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
            title.Text = "Select Period";
            fillddlPhase();
            fillgv_PeriodList();


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
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
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

    protected void fillddlPhase() {
        string strSQL = "[PMS].[fillPhases]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlPhase.DataSource = dt;
        ddlPhase.DataTextField = "Phase";
        ddlPhase.DataValueField = "ID";
        ddlPhase.DataBind();

    }

    protected void btn_submitPeriod_Click(object sender, EventArgs e)
    {
        int year = Convert.ToInt32(tbYear.Text.ToString());
        DateTime Fromdate = Convert.ToDateTime(tbFromDate.Text.ToString());
         DateTime ToDate = Convert.ToDateTime(tbToDate.Text.ToString());
        string Period = tbText.Text.ToString();
        string grace = tbgrace.Text.ToString();
        string phase = ddlPhase.SelectedValue.ToString();
        string periodid = tbPeriodID.Text.ToString();
        int Active = Convert.ToInt32(ddlActive.SelectedValue.ToString());

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();
        string strSQL = "[PMS].[InsertPeriod]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@Year", year);
        cmd.Parameters.AddWithValue("@FromDate", Fromdate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        cmd.Parameters.AddWithValue("@PeriodFor", Period);
        cmd.Parameters.AddWithValue("@MaxGrace", grace);
        cmd.Parameters.AddWithValue("@Phase", phase);
        cmd.Parameters.AddWithValue("@Active", Active);
        cmd.Parameters.AddWithValue("@PeriodID", periodid);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        ddlPhase.ClearSelection();
        tbYear.Text = string.Empty;
        tbFromDate.Text = string.Empty;
        tbToDate.Text = string.Empty;
        tbText.Text = string.Empty;
        tbgrace.Text = string.Empty;
        fillgv_PeriodList();
    }

    protected void fillgv_PeriodList() {
        string strSQL = "[PMS].[FillPeriod]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        gv_PeriodList.DataSource = dt;
        gv_PeriodList.DataBind();
    }


    protected void gv_PeriodList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string periodID = e.CommandArgument.ToString();
        GridView gv = sender as GridView;
        DataTable dt = gv.DataSource as DataTable;
        int index = 0;
        foreach(GridViewRow r in gv.Rows)
        {
            if(periodID == r.Cells[1].Text.ToString())
            {
                index = r.RowIndex;
                // Phase
                ddlPhase.SelectedItem.Selected = false;
                ddlPhase.Items.FindByText(r.Cells[7].Text.ToString()).Selected=true;
                // Active
                ddlActive.SelectedItem.Selected = false;
                ddlActive.Items.FindByText(r.Cells[8].Text.ToString()).Selected = true;
                tbYear.Text = r.Cells[2].Text.ToString();
                tbFromDate.Text = r.Cells[3].Text.ToString();
                tbToDate.Text = r.Cells[4].Text.ToString();
                tbText.Text = Server.HtmlDecode(r.Cells[5].Text.ToString());
                tbgrace.Text = r.Cells[6].Text.ToString();
                tbPeriodID.Text= r.Cells[1].Text.ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "<script>$(document).ready(function(){$('#tbToDate').datepicker({format: 'dd-MM-yyyy',autoclose: true});$('#tbFromDate').datepicker({format: 'dd-MM-yyyy',autoclose: true});$('#tbYear').datepicker({format: 'yyyy',viewMode: 'years',minViewMode: 'years',startDate: 'startYear',autoclose: true});})</script>", false);
            }
        }
    }
}