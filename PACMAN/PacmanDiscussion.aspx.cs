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

public partial class PacmanDiscussion : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private int ForEmpID { get; set; }
    private int MyRepMgr { get; set; }
    private int PacmanCycle { get; set; }
    private int RStage { get; set; }
    private int IsRepMgr { get; set; }
    private string MySkillset { get; set; }
    private DateTime StartDate { get; set; }
    private DateTime EndDate { get; set; }
    private decimal SLRating { get; set; }
    private decimal OptimizationRating { get; set; }
    private decimal EIRating { get; set; }
    private decimal AbsenteeismRating { get; set; }
    private decimal BTPRating { get; set; }
    public string lblPacmanCycle { get; set; }
    public DataTable DtOfAccountsIHandle { get; set; }
    private int IEXMgmt { get; set; }
    private int AnalyticProject { get; set; }
    private int AnalyticTimeline { get; set; }
    private int Accuracy { get; set; }
    private int AnalyticCoaching { get; set; }
    private decimal SchedulingAccuracy { get; set; }
    private decimal ForecastingAccuracy { get; set; }
    private decimal HeadcountAccuracy { get; set; }
    private decimal FinalRating { get; set; }

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
                MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                //MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
            }
        }
        catch (Exception Ex)
        {
            Console.WriteLine(Ex.Message.ToString());
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "PACMAN Discussion";

        btnSubmitPacman.Enabled = false;
        //btnSubmitPacman.Enabled = true;


        if (!IsPostBack)
        {
            fillddlReviewPeriod();
            fillddlStage();
            fillddlReportee();
            ddlStage_DataBound(sender, e);
            if (RStage == 3 || RStage == 4 || RStage == 5)
            {
                btnYesDiscussed.Enabled = false;
                //btnNotDiscussed.Enabled = false;
            }
            else if (RStage == 2)
            {
                btnYesDiscussed.Enabled = false;
                //btnNotDiscussed.Enabled = false;
                btnSubmitPacman.Enabled = true;
            }
            else
            {
                btnYesDiscussed.Enabled = true;
                //btnNotDiscussed.Enabled = true;
            }
            if (IsRepMgr == 0)
            {
                btnYesDiscussed.Enabled = false;
               // btnNotDiscussed.Enabled = false;
            }

            DtOfAccountsIHandle = getDtOfAccountsIHandle();
            showRelevantMetricPanels(MyEmpID);
            if ( Convert.ToInt32(ltl_IEX_Management.Text) != 0)
            {
                btnIEXMgmtScoreSubmit.Enabled = false;
            }
            if (Convert.ToInt32(ltl_Project.Text) != 0)
            {
                btnAnalyticProjectScoreSubmit.Enabled = false;
            }
            if (Convert.ToInt32(ltl_Coaching_and_Feedback.Text) != 0)
            {
                btnCoachingScoreSubmit.Enabled = false;
            }

        }
    }

    private DataTable getDtOfAccountsIHandle()
    {
        string strSQL = "WFMPMS.GetAllAccountsIHandle";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", MyEmpID);
        StartDate = DateTime.Today.Date;
        //cmd.Parameters.AddWithValue("@StartDate", StartDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        //dt.DefaultView.RowFilter = "InBO=1";
        //gvAllMyAccounts.DataSource = dt;
        //gvAllMyAccounts.DataBind();

        return dt;
    }

    private void getFinalRating(int ForEmpID)
    {
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());

        string strSQL = "SELECT Distinct B.id, B.Metrics, B.Weight FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics, B.Weight ";

        FinalRating = 0;
        DataTable dtWeights = my.GetData(strSQL);
        foreach (DataRow dr in dtWeights.Rows)
        {
            Decimal KPIWt = Convert.ToDecimal(dr["Weight"].ToString());
            string KPIname = dr["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Literal ltl = (Literal)Page.FindControlRecursive("ltl_" + KPIname);

            if (ltl != null)
            {
                ltl.Text = (ltl.Text == "") ? "0" : ltl.Text;
                Decimal KPIScore = Convert.ToDecimal(ltl.Text);
                FinalRating = FinalRating + (KPIScore * KPIWt);
            }
        }
        ltlfinalScore.Text = FinalRating.ToString();

    }
    private void showRelevantMetricPanels(int ForEmpID)
    {
        string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics ";

        DataTable dt = my.GetData(strSQL);
        string myPanelName = string.Empty;

        foreach (DataRow d in dt.Rows)
        {
            myPanelName = "pnl_" + d["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Control c = Page.FindControlRecursive(myPanelName);
            if (c != null)
            {
                Panel thePanel = c as Panel;
                thePanel.Visible = true;
            }
        }
    }

    private void fillddlReviewPeriod()
    {
        string strSQL = "WFMPMS.[GetPacmanCycleforPacmanDiscussion]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlReviewPeriod.DataSource = dt;
        ddlReviewPeriod.DataTextField = "TextDescription";
        ddlReviewPeriod.DataValueField = "Id";
        ddlReviewPeriod.DataBind();
        ddlReviewPeriod.SelectedIndex = 0;
    }

    private void fillddlStage()
    {
        string strSQL = "[WFMPMS].[GetReviewStage]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlStage.DataSource = dt1;
        ddlStage.DataTextField = "Stage";
        ddlStage.DataValueField = "Id";
        ddlStage.DataBind();
    }

    protected void ddlStage_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlReportee();

        ddlStage_DataBound(sender, e);
        if (RStage == 3 || RStage == 4 || RStage == 5)
        {
            btnYesDiscussed.Enabled = false;
            //btnNotDiscussed.Enabled = false;
        }
        else if (RStage == 2)
        {
            btnYesDiscussed.Enabled = false;
            //btnNotDiscussed.Enabled = false;
            btnSubmitPacman.Enabled = true;
        }
        else
        {
            btnYesDiscussed.Enabled = true;
           // btnNotDiscussed.Enabled = true;
        }
    }

    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        fillddlStage();
        fillddlReportee();
        ltlEmloyeeBanner.Text = " Performance Management Cycle : " + ddlReviewPeriod.SelectedItem.Text.ToString();
        if (ddlReportee.Items.Count > 0)
        {
            ltlEmloyeeBanner.Text = ddlReportee.SelectedItem.Text.ToString() + ltlEmloyeeBanner.Text;
        }

    }

    private void fillddlReportee()
    {
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        int stageNo = Convert.ToInt32(ddlStage.SelectedValue);

        string strSQL = "[WFMPMS].[fillEmployeePacmanDiscussion]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@stageNo", stageNo);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        DataTable dt2 = my.GetDataTableViaProcedure(ref cmd);
        ddlReportee.DataSource = dt2;
        ddlReportee.DataTextField = "Name";
        ddlReportee.DataValueField = "EmpCode";
        ddlReportee.DataBind();
        fillRelevantMetricsInPanels(MyEmpID);
        getFinalRating(MyEmpID);
    }

    private void fillRelevantMetricsInPanels(int ForEmpID)
    {
        string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics ";

        DataTable dt = my.GetData(strSQL);
        string myPanelName = string.Empty;

        foreach (DataRow d in dt.Rows)
        {
            myPanelName = "pnl_" + d["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Control c = Page.FindControlRecursive(myPanelName);
            if (c != null)
            {
                Panel thePanel = c as Panel;
                thePanel.Visible = true;
                Type thisType = this.GetType();
                MethodInfo theMethod = thisType.GetMethod("fill" + myPanelName);
                theMethod.Invoke(this, new object[] { ForEmpID });//MyEmpID


                //fillpnl_Absenteeism --Done
                //fillpnl_KPI --Done
                //fillpnl_BTP --Done
                //fillpnl_Accuracy  --Done -- Analytics KPI
                //fillpnl_Attrition --NA -- Manager KPI
                //fillpnl_Coaching_Feedback-- Analytics KPI
                //fillpnl_Escalations --Done
                //fillpnl_Forecasting_Accuracy --Empty Method
                //fillpnl_Headcount_Accuracy --Empty Method
                //fillpnl_IEX_Management --Done
                //fillpnl_On_Time_Delivery -- Analytics KPI
                //fillpnl_Projects --Done
                //fillpnl_Real_Time_Optimization --Done
                //fillpnl_Revenue_Cost_optimization -- Manager KPI
                //fillpnl_Scheduling_Accuracy
            }
        }
    }
    protected void btnYesDiscussed_Click(object sender, EventArgs e)
    {
        btnSubmitPacman.Enabled = true;
        btnYesDiscussed.Enabled = false;
        //btnNotDiscussed.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        //int PreviousStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        int PreviousStage = 1;
        int Stage = 2;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        //fillddlReportee();
    }
    protected void ddlStage_DataBound(object sender, EventArgs e)
    {
        RStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        strSQL = "[WFMPMS].[GetIsRepMgr]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
                IsRepMgr = Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
    protected void btnSubmitPacman_Click(object sender, EventArgs e)
    {
        InsertTotblFinalKPI(ForEmpID);

        btnYesDiscussed.Enabled = false;
        //btnNotDiscussed.Enabled = false;
        btnSubmitPacman.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        //int PreviousStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        int PreviousStage = 2;
        int Stage = 3;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        fillddlReportee();
    }

    private void InsertTotblFinalKPI(int ForEmpID)
    {
        int IsSPI = Convert.ToInt32(ddlSPI.SelectedValue.ToString());
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());

        strSQL = " SELECT Distinct B.Id, A.EmpCode,'' as PacmanCycle,B.SkillsetId, B.Metrics as Metric ";
        strSQL += " , B.DataLevel, B.Weight as Weightage, '' as Acheived, '' as Score";
        strSQL += " , getdate() as Date FROM[CWFM_Umang].[WFMPMS].[tblEmp2Account] A ";
        strSQL += " inner join[WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId ";
        strSQL += " where EmpCode = " + ForEmpID + " and[Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.Id, B.Metrics, B.Weight ";

        FinalRating = 0;
        DataTable dtWeights = my.GetData(strSQL);
        strSQL = "[WFMPMS].[InsertFinalKPI]";

        foreach (DataRow dr in dtWeights.Rows)
        {
            Decimal KPIWt = Convert.ToDecimal(dr["Weightage"].ToString());
            string KPIname = dr["Metric"].ToString().Replace("&", "").Replace(" ", "_");
            Literal ltl = (Literal)Page.FindControlRecursive("ltl_" + KPIname);

            if (ltl != null)
            {

                Decimal KPIScore = Convert.ToDecimal(ltl.Text);
                if (IsSPI == 0)
                { FinalRating = KPIScore * KPIWt; }
                else { FinalRating = 3; }

                SqlCommand cmd = new SqlCommand(strSQL);
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                cmd.Parameters.AddWithValue("@SkillsetId", Convert.ToDecimal(dr["SkillsetId"].ToString()));
                cmd.Parameters.AddWithValue("@Metric", KPIname);
                cmd.Parameters.AddWithValue("@DataLevel", dr["DataLevel"].ToString());
                cmd.Parameters.AddWithValue("@Weightage", Convert.ToDecimal(dr["Weightage"].ToString()));
                cmd.Parameters.AddWithValue("@Achieved", KPIScore);
                cmd.Parameters.AddWithValue("@Score", FinalRating);
                my.ExecuteDMLCommand(ref cmd, strSQL, "S");
                cmd.Dispose();

            }
        }
    }

    private void clearIEXMgmtScorefields()
    {
        ddlIEXMgmtScore.ClearSelection();
        txtIEXMgmtComments.Text = string.Empty;
    }

    public void fillpnl_KPI(int ForEmpID)
    {

        string strSQL = "WFMPMS.getSLSummaryForPACMAN";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt != null)
        {
            GridView gvPrimaryKPI = new GridView();
            gvPrimaryKPI.ID = "gvPrimaryKPI";
            gvPrimaryKPI.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");
            DataRow dr = dt.NewRow();

            gvPrimaryKPI.DataSource = dt;
            gvPrimaryKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";

            gvPrimaryKPI.DataBind();
            if (dt.Rows.Count > 0)
            {
                gvPrimaryKPI.Rows[dt.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvPrimaryKPI.Rows[dt.Rows.Count - 1].Font.Bold = true;
                gvPrimaryKPI.PreRender += gv_PreRender;
                bool slrating = false;
                decimal dec_slrating;
                slrating = Decimal.TryParse(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString(), out dec_slrating);
                if(slrating)
                {
                    SLRating = dec_slrating;
                }
                else
                {
                    SLRating = 0;
                }
                ltlPrimaryKPI.Text = "Primary KPIname : Service Level &nbsp= &nbsp";
                ltl_KPI.Text = SLRating.ToString();
                pnlKPI.Controls.Add(gvPrimaryKPI);
            }
            else
            {
                ltlPrimaryKPI.Text = "Primary KPIname : Service Level &nbsp= &nbsp";// + "No Data found";
                ltl_KPI.Text = String.Empty;
            }

        }
        else
        {
            ltlPrimaryKPI.Text = "Primary KPIname : Service Level &nbsp= &nbsp";// + "No Data found";
            ltl_KPI.Text = String.Empty;
        }


    }

    protected void btnIEXMgmtScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertIEXManagementScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int score = Convert.ToInt32(ddlIEXMgmtScore.SelectedItem.Value.ToString());
        string comments = txtIEXMgmtComments.Text.ToString();

        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", score);
        cmd.Parameters.AddWithValue("@Comments", comments);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlIEX_Management.Text = "IEX Management &nbsp= &nbsp" + "<div class=\"pull-right header\">" + score + "</div>";
        clearIEXMgmtScorefields();
    }

    protected void ddlReportee_SelectedIndexChanged(object sender, EventArgs e)
    {
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        fillRelevantMetricsInPanels(ForEmpID);
        getFinalRating(MyEmpID);
        if (Convert.ToInt32(ltl_IEX_Management.Text) != 0)
        {
            btnIEXMgmtScoreSubmit.Enabled = false;
        }
    }

    protected void btnAnalyticProjectScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertAnalyticsProjectsScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int scoreProjects = Convert.ToInt32(ddlAnalyticProject.SelectedItem.Value.ToString());
        string commentsProjects = txtAnalyticProject.Text.ToString();

        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", scoreProjects);
        cmd.Parameters.AddWithValue("@Comments", commentsProjects);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlProject.Text = "Projects &nbsp= &nbsp" + "<div class=\"pull-right header\">" + scoreProjects + "</div>";
        clearAnalyticProjectScorefields();

    }

    private void clearAnalyticProjectScorefields()
    {
        ddlAnalyticProject.ClearSelection();
        txtAnalyticProject.Text = string.Empty;
    }

    protected void btnCoachingScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertAnalyticsCoachingScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int scoreCoaching = Convert.ToInt32(ddlCoaching.SelectedItem.Value.ToString());
        string commentsCoaching = txtCoachingComments.Text.ToString();

        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", scoreCoaching);
        cmd.Parameters.AddWithValue("@Comments", commentsCoaching);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp" + "<div class=\"pull-right header\">" + scoreCoaching + "</div>";
        clearAnalyticCoachingScorefields();
    }

    private void clearAnalyticCoachingScorefields()
    {
        ddlCoaching.ClearSelection();
        txtCoachingComments.Text = string.Empty;
    }

    private void fillltlfinalScore(int ForEmpID)
    {
        int FinalScore = 0;
        strSQL = "[WFMPMS].[getPacmanFinalScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        FinalScore = Convert.ToInt32(sdr.GetValue(0));
                        ltlfinalScore.Text = FinalScore.ToString();
                    }
                    else
                    { ltlfinalScore.Text = "Pacman discussion not completed"; }
                }

            }
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
    
    #region Analytics KPIs
    public void fillpnl_Coaching_and_Feedback(int ForEmpID)
    {
        AnalyticCoaching = 0;
        strSQL = "[WFMPMS].[getAnalyticCoachingScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        //string AnalyticCoaching =  sdr.GetValue(0).ToString();// Convert.ToInt32(sdr.GetValue(0));
                       AnalyticCoaching = Convert.ToInt32(sdr.GetValue(0));
                        ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp";
                        ltl_Coaching_and_Feedback.Text = AnalyticCoaching.ToString();

                        //if (AnalyticCoaching != null)
                        //{
                        //    ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp";
                        //    ltl_Coaching_and_Feedback.Text = AnalyticCoaching.ToString();
                        //}
                        
                    }
                    else
                    {
                        int noVal = 0;
                        ltlCoachingFeedback.Text = noVal.ToString();
                        ltl_Coaching_and_Feedback.Text = noVal.ToString();
                    }
                }
                
            }

        }
    }
    public void fillpnl_On_Time_Delivery(int ForEmpID)
    {
        AnalyticTimeline = 0;
        strSQL = "[WFMPMS].[GetAnalyticTimelineScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        string val = sdr.GetValue(0).ToString();
                        //AnalyticTimeline = Convert.ToInt32(sdr.GetValue(0));
                        if (val != null)
                        {
                            ltlOntimeDelivery.Text = "On Time Delivery &nbsp= &nbsp";
                            ltl_On_time_Delivery.Text = val.ToString();
                        }
                        else
                        {
                            int noVal = 0;
                            ltlOntimeDelivery.Text = noVal.ToString();
                            ltl_On_time_Delivery.Text = noVal.ToString();
                        }

                    }
                    //else {
                    //    int noVal = 0;
                    //    ltlOntimeDelivery.Text = noVal.ToString();
                    //}
                }

            }

        }
    }
    public void fillpnl_Absenteeism(int ForEmpID)
    {


        AbsenteeismRating = 0;
        strSQL = "[WFMPMS].[GetSelfAttendanceScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        AbsenteeismRating = Convert.ToInt32(sdr.GetValue(0));
                        ltlAbsenteeism.Text = "Self-Attendance &nbsp= &nbsp";
                        ltl_Absenteeism.Text = AbsenteeismRating.ToString();
                    }
                    else
                    {
                        int noVal = 0;
                        ltlAbsenteeism.Text = noVal.ToString();
                        ltl_Absenteeism.Text = noVal.ToString();
                    }
                }
                
            }

        }
    }
    public void fillpnl_Accuracy(int ForEmpID)
    {
        Accuracy = 0;
        strSQL = "[WFMPMS].[GetAnalyticAccuracyScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        Accuracy = Convert.ToInt32(sdr.GetValue(0));
                        ltlAccuracy.Text = "Accuracy &nbsp= &nbsp" ;
                        ltl_Accuracy.Text = Accuracy.ToString();
                    }
                    else
                    {
                        int noVal = 0;
                        ltlAccuracy.Text = noVal.ToString();
                        ltl_Accuracy.Text = noVal.ToString();
                    }
                }
                //ltlAccuracy.Text = "Accuracy &nbsp= &nbsp" + "<div class=\"pull-right header\">" + Accuracy + "</div>";
            }

        }
    }
    public void fillpnl_Projects(int ForEmpID)
    {
        AnalyticProject = 0;
        strSQL = "[WFMPMS].[getAnalyticProjectScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        AnalyticProject = Convert.ToInt32(sdr.GetValue(0));
                        ltlProject.Text = "Projects &nbsp= &nbsp";
                        ltl_Project.Text = AnalyticProject.ToString();
                    }
                    else
                    {
                        int noVal = 0;
                        ltlProject.Text = noVal.ToString();
                        ltl_Project.Text = noVal.ToString();
                    }

                }
                
            }

        }
    }
    #endregion Analytics KPIs
    #region Manager
    public void fillpnl_Attrition(int ForEmpID)
    {
        // Not in Scope - not defined.
    }
    public void fillpnl_Revenue_Cost_optimization(int ForEmpID)
    {
        // Not in Scope - not defined. 
    }
    #endregion
    #region Planning
    public void fillpnl_BTP(int ForEmpID)
    {
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());


        strSQL = "[WFMPMS].GetBTPByEmp";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@Month", StartDate);
        dt = my.GetDataTableViaProcedure(ref cmd);


        GridView gvBTP = new GridView();
        gvBTP.ID = "gvBTP";
        gvBTP.AutoGenerateColumns = true;

        gvBTP.DataSource = dt;
        gvBTP.CssClass = "table DataTable table-condensed table-bordered table-responsive";

        gvBTP.DataBind();
        if (dt != null && dt.Rows.Count > 0)
        {
            gvBTP.Rows[gvBTP.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvBTP.Rows[gvBTP.Rows.Count - 1].Font.Bold = true;
            gvBTP.PreRender += gv_PreRender;
            BTPRating = Convert.ToDecimal(dt.Rows[0]["Rating"].ToString());
        }
        else
        {
            ltlBTP.Text = string.Empty;
        }
        ltlBTP.Text = "Billed To Pay &nbsp: &nbsp";
        pnlBTP.Controls.Add(gvBTP);
        ltl_BTP.Text = BTPRating.ToString();
    }
    public void fillpnl_Escalations(int ForEmpID)
    {
        EIRating = 0;
        strSQL = "[WFMPMS].[GetEscalationInitiativeScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                cmd.Parameters.AddWithValue("@total", EIRating);
                cmd.Parameters["@total"].Direction = ParameterDirection.Output;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                EIRating = Convert.ToInt32(cmd.Parameters["@total"].Value.ToString());
                ltlEI.Text = "Escalations & Initiatives &nbsp= &nbsp";
                ltl_Escalations.Text = EIRating.ToString();

                if (dt != null)
                {
                    GridView gvEscalations = new GridView();
                    gvEscalations.ID = "gvEscalations";
                    gvEscalations.AutoGenerateColumns = true;
                    //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

                    DataRow dr = dt.NewRow();

                    gvEscalations.DataSource = dt;
                    gvEscalations.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                    gvEscalations.DataBind();
                    if (dt.Rows.Count > 0)
                    {
                        gvEscalations.Rows[gvEscalations.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                        gvEscalations.Rows[gvEscalations.Rows.Count - 1].Font.Bold = true;
                        gvEscalations.PreRender += gv_PreRender;
                    }


                    pnlEscalations.Controls.Add(gvEscalations);
                }
                else
                {
                    ltl_Escalations.Text = string.Empty;
                }
            }

        }
    }
    public void fillpnl_Forecasting_Accuracy(int ForEmpID)
    {
        //WFMPMS.getForecastAccuracyScore
        string strSQL = "[WFMPMS].[IEXForecastingScore]";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt != null)
        {
            GridView gvForecastingAccuracy = new GridView();
            gvForecastingAccuracy.ID = "gvForecastingAccuracy";
            gvForecastingAccuracy.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

            DataRow dr = dt.NewRow();

            gvForecastingAccuracy.DataSource = dt;
            gvForecastingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvForecastingAccuracy.DataBind();
            if (dt.Rows.Count > 0)
            {
                gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].Font.Bold = true;
                gvForecastingAccuracy.PreRender += gv_PreRender;
                ForecastingAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                ltl_Forecasting_Accuracy.Text = ForecastingAccuracy.ToString();
            }


            pnlForecasting_Accuracy.Controls.Add(gvForecastingAccuracy);
        }
        else
        {
            ltl_Forecasting_Accuracy.Text = "Forecasting Accuracy &nbsp= &nbsp" + "No Data found";
        }
    }
    public void fillpnl_Headcount_Accuracy(int ForEmpID)
    {
        //WFMPMS.getHeadcountAccuracyScore
        string strSQL = "WFMPMS.getHeadCountAccuracyScore";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt != null)
        {
            GridView gvHeadcountAccuracy = new GridView();
            gvHeadcountAccuracy.ID = "gvHeadcountAccuracy";
            gvHeadcountAccuracy.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

            DataRow dr = dt.NewRow();

            gvHeadcountAccuracy.DataSource = dt;
            gvHeadcountAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvHeadcountAccuracy.DataBind();
            if (dt.Rows.Count > 0)
            {
                gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].Font.Bold = true;
                gvHeadcountAccuracy.PreRender += gv_PreRender;
                HeadcountAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                ltl_Headcount_Accuracy.Text = HeadcountAccuracy.ToString();
            }


            pnlHeadcount_Accuracy.Controls.Add(gvHeadcountAccuracy);
        }
        else
        {
            ltlHeadcount_Accuracy.Text = "Headcount Accuracy &nbsp= &nbsp" + "No Data found";
        }
    }
    #endregion
    #region RTA
    public void fillpnl_Real_Time_Optimization(int ForEmpID)
    {

        string strSQL = "WFMPMS.getSLOptimizationSummaryForPACMAN";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt.Rows.Count > 0)
        {
            GridView gvOptimizationKPI = new GridView();
            gvOptimizationKPI.AutoGenerateColumns = true;

            gvOptimizationKPI.DataSource = dt;
            gvOptimizationKPI.DataBind();
            gvOptimizationKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].Font.Bold = true;
            OptimizationRating = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
            ltlOptimization.Text = "Real Time Optimization &nbsp= &nbsp";
            ltl_Real_Time_Optimization.Text = OptimizationRating.ToString();
            pnlOptimization.Controls.Add(gvOptimizationKPI);

            gvOptimizationKPI.PreRender += gv_PreRender;
        }


    }
    #endregion
    #region Scheduling
    public void fillpnl_Scheduling_Accuracy(int ForEmpID)
    {
        //WFMPMS.getSchedulingAccuracyScore
        string strSQL = "[WFMPMS].[IEXSchedulingScore]";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt != null && dt.Rows.Count > 0)
        {
            GridView gvSchedulingAccuracy = new GridView();
            gvSchedulingAccuracy.ID = "gvSchedulingAccuracy";
            gvSchedulingAccuracy.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

            DataRow dr = dt.NewRow();

            gvSchedulingAccuracy.DataSource = dt;
            gvSchedulingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvSchedulingAccuracy.DataBind();


            gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].Font.Bold = true;
            gvSchedulingAccuracy.PreRender += gv_PreRender;
            SchedulingAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
            ltl_Scheduling_Accuracy.Text = SchedulingAccuracy.ToString();

            pnlSchedulingAccuracy.Controls.Add(gvSchedulingAccuracy);
        }
        else
        {
            ltlSchedulingAccuracy.Text = "Scheduling Accuracy : ";
            ltl_Scheduling_Accuracy.Text = "0";

        }
    }
    public void fillpnl_IEX_Management(int ForEmpID)
    {
        IEXMgmt = 0;
        strSQL = "[WFMPMS].[GetIEXMgmtScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        IEXMgmt = Convert.ToInt32(sdr.GetValue(0));
                    }
                }
                ltlIEX_Management.Text = "IEX Management &nbsp= &nbsp";
                ltl_IEX_Management.Text = IEXMgmt.ToString();
            }

        }
    }
    #endregion

    protected void btnDownload_Click(object sender, EventArgs e)
    {
        LinkButton b = sender as LinkButton;

        string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + MyEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics ";

        DataTable dt = my.GetData(strSQL);
        string myPanelName = string.Empty;

        //foreach (DataRow d in dt.Rows)
        //{
        //    // For Troubleshooting : Paras - Please remove when not needed.
        //    //if (d["Metrics"].ToString().Replace("&", "").Replace(" ", "_") == "BTP")
        //    //{
        //    myPanelName = "pnl_" + d["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
        //    Control c = Page.FindControlRecursive(myPanelName);
        //    if (c != null)
        //    {
        //        Panel thePanel = c as Panel;
        //        thePanel.Visible = true;
        //        Type thisType = this.GetType();
        //        MethodInfo theMethod = thisType.GetMethod("fill" + myPanelName);
        //        try
        //        {
        //            theMethod.Invoke(this, new object[] { MyEmpID });
        //        }
        //        catch (Exception Ex)
        //        {
        //            Response.Write(Ex.Message.ToString());
        //        }
        //        finally
        //        {
        //            my.close_conn();
        //        }
        //    }
        //}

        //my = new Helper();
        //string FileName = "Sitel " + ddlSite.SelectedItem.ToString() + " Roster ";

        //string strSQL;
        //if (rdoCustomDateSelection.Checked)
        //{
        //    if (ddlFromDate.Text.Length > 0 && ddlToDate.Text.Length > 0)
        //    {
        //        fromDate = Convert.ToDateTime(ddlFromDate.Text);
        //        toDate = Convert.ToDateTime(ddlToDate.Text);
        //        // Swap dates if From is After To date.
        //        if (fromDate > toDate)
        //        {
        //            ddlFromDate.Text = toDate.ToString();
        //            ddlToDate.Text = fromDate.ToString();
        //            fromDate = toDate;
        //            toDate = Convert.ToDateTime(ddlFromDate.Text);
        //        }
        //    }
        //}
        //else if (rdoWeekSelection.Checked)
        //{
        //    strSQL = "SELECT [WeekId],[FrDate],[ToDate] FROM [CWFM_Umang].[WFMP].[tblRstWeeks] ";
        //    strSQL += " where [WeekId] = " + ddlWeekSelection.SelectedValue;
        //    DataTable dt = my.GetData(strSQL);
        //    fromDate = Convert.ToDateTime(dt.Rows[0]["FrDate"].ToString());
        //    toDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        //    dt.Dispose();
        //}
        //else
        //{

        //}

        //if (fromDate <= toDate)
        //{
        //    strSQL = "[WFMP].[Roster_GetAdminFormatRoster]";
        //    SqlCommand cmd = new SqlCommand(strSQL);
        //    cmd.CommandType = CommandType.StoredProcedure;
        //    cmd.Parameters.AddWithValue("@FromDate", fromDate);
        //    cmd.Parameters.AddWithValue("@ToDate", toDate);
        //    DataTable d = my.GetDataTableViaProcedure(ref cmd);
        //    d.Columns.Remove("ShiftID");
        //    d.Columns.Remove("CountryID");
        //    d.Columns.Remove("SiteID");
        //    d.Columns.Remove("LOBID");
        //    d.Columns.Remove("ResType");

        //    string[] rowFields = { "ECN", "NAME", "PROCESS", "TL_ECN", "TEAM_LEADER" };
        //    string[] columnFields = { "ShiftDate" };
        //    Pivot pvt = new Pivot(d);
        //    d = pvt.PivotData("ShiftCode", AggregateFunction.First, rowFields, columnFields);
        //    DateTime myDate;
        //    foreach (DataColumn dc in d.Columns)
        //    {
        //        if (DateTime.TryParse(dc.ColumnName, out myDate))
        //        {
        //            dc.ColumnName = myDate.ToString("ddd dd-MMM-yyyy");
        //            //dc.ColumnName = myDate.ToString("(ddd) dd-MMM-yyyy");
        //            //dc.ColumnName = myDate.ToString("ddd(dd)");
        //        }
        //    }


        //    //// Use only if you wish to see what's getting sent to the csv download.
        //    //gvRoster.DataSource = d;
        //    //gvRoster.DataBind();

        //    FileName += fromDate.ToString("dd-MMM-yyyy") + " to " + toDate.ToString("dd-MMM-yyyy") + ".csv";
        //    //Get the physical path to the file.
        //    string FilePath = Server.MapPath("Sitel//roster_downloads//" + FileName);
        //    using (var textWriter = File.CreateText(FilePath))
        //    {
        //        using (var csv = new CsvWriter(textWriter))
        //        {
        //            // Write columns
        //            foreach (DataColumn column in d.Columns)
        //            {
        //                csv.WriteField(column.ColumnName);
        //            }
        //            csv.NextRecord();

        //            // Write row values
        //            foreach (DataRow row in d.Rows)
        //            {
        //                for (var i = 0; i < d.Columns.Count; i++)
        //                {
        //                    csv.WriteField(row[i]);
        //                }
        //                csv.NextRecord();
        //            }
        //        }
        //    }

        //    //Send the CSV file as a Download.
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.AddHeader("content-disposition", "attachment;filename=" + FileName);
        //    Response.Charset = "";
        //    Response.ContentType = "application/text";
        //    Response.Output.Write(File.ReadAllText(FilePath));
        //    Response.Flush();
        //    Response.End();
        //}
    }

}