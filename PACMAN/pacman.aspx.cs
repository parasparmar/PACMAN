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
    private DateTime StartDate { get; set; }
    private DateTime EndDate { get; set; }
    private decimal SLRating { get; set; }
    private decimal OptimizationRating { get; set; }

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
            fillddlReviewPeriod();

        }
        else
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
        }

    }

    private void filltblKPI()
    {
        string strSQL = "[WFMPMS].[getSLForEmpAndAccount_511TOT1]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", MyEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        tblKPI.DataSource = dt;
        tblKPI.DataBind();

    }

    private void fillddlReviewPeriod()
    {
        string strSQL = "WFMPMS.fillPacmanCycleSelectionDropdownList";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlReviewPeriod.DataSource = dt;
        ddlReviewPeriod.DataTextField = "TextDescription";
        ddlReviewPeriod.DataValueField = "Id";
        ddlReviewPeriod.DataBind();
    }

    private void fillgvPrimaryKPI()
    {

        string strSQL = "WFMPMS.getSLSummaryForPACMAN";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
                cmd.Parameters.AddWithValue("@StartDate", StartDate);
                cmd.Parameters.AddWithValue("@EndDate", EndDate);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);
                DataTable dt = ds.Tables[0];
                
                GridView gvPrimaryKPI = new GridView();
                gvPrimaryKPI.ID = "gvPrimaryKPI";
                gvPrimaryKPI.AutoGenerateColumns = true;

                
                dt.Columns.Add("Calculation");
                DataRow dr = dt.NewRow();

                dt.ImportRow(ds.Tables[1].Rows[0]);
                gvPrimaryKPI.DataSource = dt;
                gvPrimaryKPI.CssClass = "table table-condensed table-bordered table-responsive";
                
                gvPrimaryKPI.DataBind();
                gvPrimaryKPI.Rows[gvPrimaryKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvPrimaryKPI.Rows[gvPrimaryKPI.Rows.Count - 1].Font.Bold = true;

                SLRating = Convert.ToDecimal(ds.Tables[1].Rows[0]["Rating"].ToString());
                ltlPrimaryKPI.Text = "Primary KPI : Service Level &nbsp= &nbsp" + "<div class=\"pull-right header\">" + SLRating + "</div>";
                pnlKPI.Controls.Add(gvPrimaryKPI);

            }

        }
    }

    private void fillgvRealTimeOptimization()
    {
        
        string strSQL = "WFMPMS.getOptimizationSummaryForPACMAN";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
                cmd.Parameters.AddWithValue("@StartDate", StartDate);
                cmd.Parameters.AddWithValue("@EndDate", EndDate);
                
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                GridView gvOptimizationKPI = new GridView();
                gvOptimizationKPI.ID = "gvOptimizationKPI";
                gvOptimizationKPI.AutoGenerateColumns = true;
                DataTable dt = ds.Tables[0];
                dt.Columns.Add("Calculation");
                DataRow dr = dt.NewRow();
                

                dt.ImportRow(ds.Tables[1].Rows[0]);

                gvOptimizationKPI.DataSource = dt;
                gvOptimizationKPI.CssClass = "table table-condensed table-bordered table-responsive";
                
                gvOptimizationKPI.DataBind();
                gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].Font.Bold = true;
                OptimizationRating = Convert.ToDecimal(ds.Tables[1].Rows[0]["Rating"].ToString());
                ltlOptimizationKPI.Text = "Primary KPI : Service Level &nbsp= &nbsp" + "<div class=\"pull-right header\">" + OptimizationRating + "</div>";
                pnlOptimization.Controls.Add(gvOptimizationKPI);

            }

        }
    }

    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        int Id = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + Id;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());

        fillgvPrimaryKPI();
        fillgvRealTimeOptimization();
    }
}