using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Reflection;
using System.Linq.Expressions;
using System.IO;
using CsvHelper;

public partial class pacman : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private int ForEmpID { get; set; }
    private int PeriodID { get; set; }
    private DateTime StartDate { get; set; }
    private DateTime EndDate { get; set; }
    private decimal FinalRating { get; set; }
    public bool xShowButtons { get; set; }
    public DataTable DtProcName { get; set; }


    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

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
                MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
                ForEmpID = MyEmpID;
            }
        }
        catch (Exception Ex)
        {
            Console.WriteLine(Ex.Message.ToString());
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "PACMAN";

        if (!IsPostBack)
        {
            fillddlReviewPeriod();
            enableButtons();
        }

    }
    private void fillddlReviewPeriod()
    {
        string strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;

        DataTable dtReportee = my.GetData(ref cmd);
        ddlReviewPeriod.DataSource = dtReportee;
        ddlReviewPeriod.DataTextField = "Period";
        ddlReviewPeriod.DataValueField = "PeriodID";
        ddlReviewPeriod.DataBind();
        ddlReviewPeriod.Items.Insert(0, new ListItem("Please Select", "0"));
        ddlReviewPeriod.SelectedIndex = 0;
    }
    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        clearRP();
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        if (PeriodID > 0)
        {
            string strSQL = "SELECT [FromDate],[ToDate] FROM [PMS].[PeriodMst] where [PeriodID] =" + PeriodID;
            DataTable dt = my.GetData(strSQL);
            StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
            EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
            populateHeaders();
            populateHeaders();
            fillRP(ForEmpID);
            enableButtons();
        }
    }
    private void enableButtons()
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "PMS.EnableAcknowledgeButton";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        DataTable dt1 = my.GetData(ref cmd);

        if (dt1 != null && dt1.Rows.Count == 1)
        {
            btnAcknowledged.Enabled = dt1.Rows[0]["btnAcknowledged"].ToString() == "1" ? true : false;
            if (btnAcknowledged.Enabled) { pnlSubmission.Visible = true; }
        }
        else
        {
            btnAcknowledged.Enabled = false;
            pnlSubmission.Visible = false;
        }

    }
    private void populateHeaders()
    {
        ltlFinalRating.Text = "0";
        string strSQL = "Select Distinct SKILLSET as Role from getKPIWiseResponsibilities() where Employee_id = @EmpCode";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dtReportee = my.GetData(ref cmd);
        if (dtReportee != null)
        {
            string Role = string.Empty;
            Role = dtReportee.Rows[0]["Role"].ToString();
            ltlEmployeeBanner.Text = ddlReviewPeriod.SelectedItem.Text.ToString() + "( " + MyEmpID + " ) | Role : " + Role;
        }
        else
        {
            ltlEmployeeBanner.Text = string.Empty;
        }
    }
    private void fillStartAndEndDates()
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [PMS].[PeriodMst] where [PeriodID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        if (dt != null && dt.Rows.Count > 0)
        {
            StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
            EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());

        }
        else
        {
            StartDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
            EndDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 31);

        }

    }
    protected void btnAcknowledged_Click(object sender, EventArgs e)
    {

        // To do : For this emp, LockID = 1 and SPI = false in PMS.Eligibility against this empcode and periodid

        strSQL = "[PMS].[SubmitAcknowledgement]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        my.ExecuteDMLCommand(ref cmd, strSQL, "S");
        clearRP();
    }
    private void fillRP(int ForEmpID)
    {
        //PMS.FillKPI 880343,5
        rp.Visible = true;
        int PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue.ToString());
        fillStartAndEndDates();
        strSQL = "PMS.FillKPI";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);

        DtProcName = my.GetData(ref cmd);
        rp.DataSource = DtProcName;
        rp.DataBind();
        populateGVOverall();
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
    protected void rp_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType.ToString() == "Item" || e.Item.ItemType.ToString() == "AlternatingItem")
        {
            GridView gv = e.Item.FindControlRecursive("gvKPI") as GridView;
            gv.Columns.Clear();

            if (gv != null)
            {
                fillStartAndEndDates();
                if (DtProcName != null && DtProcName.Rows.Count > 0)
                {
                    bool isManual;
                    string procName = string.Empty;
                    string Metric = string.Empty;
                    foreach (DataRow dr in DtProcName.Rows)
                    {
                        isManual = Convert.ToBoolean(dr["isManual"].ToString());
                        procName = dr["ProcName"].ToString();
                        Literal ltlKPIName = e.Item.FindControlRecursive("ltlKPIName") as Literal;
                        Metric = dr["Metric"].ToString();

                        if (ltlKPIName.Text == Metric)
                        {
                            int KPIId = Convert.ToInt32(dr["KPIID"].ToString());

                            pnlSubmission.Visible = xShowButtons;
                            if (!isManual && procName.Length > 0)
                            {
                                SqlCommand cmd = new SqlCommand();
                                cmd.CommandText = procName;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                                //cmd.Parameters.AddWithValue("@StartDate", StartDate);
                                //cmd.Parameters.AddWithValue("@EndDate", EndDate);
                                cmd.Parameters.AddWithValue("@StartDate", "20180401");
                                cmd.Parameters.AddWithValue("@EndDate", "20180430");

                                DataTable dt = my.GetData(ref cmd);
                                gv.DataSource = dt;
                                gv.DataBind();
                                string Rating = string.Empty;
                                DataRow[] drs = dt.Select("Account = 'Grand Total'");
                                if (drs.Length == 1)
                                {
                                    foreach (DataRow r in drs)
                                    {
                                        Rating = r["Rating"].ToString();
                                    }
                                    Literal ltlfinalScore = e.Item.FindControlRecursive("ltlKPIScore") as Literal;
                                    ltlfinalScore.Text = Rating.ToString();
                                    if (!string.IsNullOrEmpty(Rating))
                                    {
                                        Decimal KPIRating = Convert.ToDecimal(Rating);
                                        Decimal KPIWtg = Convert.ToDecimal(dr["KPIWtg"].ToString());
                                        FinalRating += KPIRating * KPIWtg;
                                        ltlFinalRating.Text = Math.Round(FinalRating, 2).ToString();
                                    }
                                    else
                                    { ltlFinalRating.Text = string.Empty; }
                                    xShowButtons = true;
                                }
                            }
                        }
                    }
                }
                else
                {
                    rp.Visible = false;
                    ltlFinalRating.Text = "0";
                }
            }
            pnlSubmission.Visible = xShowButtons;
        }
    }
    private void clearRP()
    {
        rp.Visible = false;
        ltlFinalRating.Text = "0";
        ltlEmployeeBanner.Text = string.Empty;
    }
    protected void btnManualScoreSubmit_Click(object sender, EventArgs e)
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        Button btn = sender as Button;
        int KPIID = Convert.ToInt32(btn.CommandArgument.ToString());
        DropDownList ddl = Page.FindControlRecursive("ddlManualScore") as DropDownList;
        TextBox tb = Page.FindControlRecursive("txtManualComments") as TextBox;
        if (ddl != null && tb != null)
        {
            decimal KPIRating = Convert.ToDecimal(ddl.SelectedValue.ToString());
            string KPIComments = tb.Text;

            string strSQL = "PMS.SaveKPIManualRating";
            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
            cmd.Parameters.AddWithValue("@KPIID", KPIID);
            cmd.Parameters.AddWithValue("@KPIRating", KPIRating);
            cmd.Parameters.AddWithValue("@KPIComments", KPIComments);
            cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
            int rowsAffected = my.ExecuteDMLCommand(ref cmd, strSQL, "S");

        }
    }
    private void populateGVOverall()
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "PMS.ShowEmpPacmanDetails";
        SqlConnection cn = new SqlConnection(my.getConnectionString());
        cn.Open();
        SqlCommand cmd = new SqlCommand(strSQL, cn);

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        da.Fill(ds);
        DataTable dtOverall = ds.Tables[0];
        DataTable dtPhase = ds.Tables[1];
        gvOverAll.DataSource = dtOverall;
        gvOverAll.DataBind();

        ltlOverAll.Text = dtPhase.Rows[0][0].ToString();



    }
}

